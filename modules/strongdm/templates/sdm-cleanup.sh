#!/bin/bash

MAX_UNHEALTHY=${2:-50}

command -v jq >/dev/null && command -v netcat >/dev/null || { apt-get update && apt-get install -y jq netcat; }

function test_ssh_host() {
	# true if we can open a TCP connection to the SSH port
	netcat -w 1 -z "$1" 22

	# We could actually do this test without netcat using bash's built in TCP support
	#   timeout -k 1 1 bash -c ": </dev/tcp/${1}/22"
}

function deregister_server_by_id() {
	# Unfortunately, this uses a fuzzy search, where "ip-10-123-11-2" matches "ip-10-123-11-22" as well,
	# and the command gives an error saying that there are 2 matches and
	# you need to specify --all to delete all of them. Nice safeguard, but it means we neeed to use the
	# fixed-length ID in order to safely delete a single server.
	sdm admin ssh delete "$1"
}

function update_status_of_server_by_id() {
	# Force a health check by updating a tag on the server
	sdm admin servers update ssh --id "$1" --tags "ForcedHealthcheckAt=$(date --iso-8601=seconds)"
}

function main() {
	local unhealthy_only=false
	local sdm_dockerized_save="$SDM_DOCKERIZED"

	# We have to set SDM_DOCKERIZED=false (or at least, cannot allow it to be set "true")
	# in order to get the clean output of `sdm`. With is set true, which is the default
	# for the Docker image, `sdm` outputs logging information to `stdout` along with
	# other information, such as the JSON output we want.
	SDM_DOCKERIZED=false

	status_file="/tmp/sdm-status.$$.json"
	sdm admin ssh list -e -j >"$status_file"

	# It is OK now for us to get logging info on `sdm` since we are done capturing output to parse
	SDM_DOCKERIZED="$sdm_dockerized_save"

	healthy_hosts=($(jq -r '.[] | select(.healthy == "true") | "\(.name)%\(.hostname)%\(.id)"' "$status_file"))
	printf "Found %d SSH servers marked healthy\n\n" "${#healthy_hosts[@]}"

	unhealthy_hosts=($(jq -r '.[] | select(.healthy != "true") | "\(.name)%\(.hostname)%\(.id)"' "$status_file"))
	printf "Found %d SSH servers marked unhealthy\n\n" "${#unhealthy_hosts[@]}"

	# "$status_file" has now been parsed into $healthy_hosts and $unhealthy_hosts, so we can delete it
	rm -f "$status_file"

	if (("${#unhealthy_hosts[@]}" > "$MAX_UNHEALTHY")); then
		printf "Limiting checks to first %d unhealthy hosts\n" "$MAX_UNHEALTHY"
		unhealthy_hosts=("${unhealthy_hosts[@]:0:$MAX_UNHEALTHY}")
		unhealthy_only=true
	fi

	printf "Checking servers marked unhealthy...\n\n"

	for host in "${unhealthy_hosts[@]}"; do
		ids=(${host//%/ })
		name="${ids[0]}"
		ip="${ids[1]}"
		id="${ids[2]}"
		printf "Testing connectivity to unhealthy server %s... " "$name"
		if test_ssh_host "$ip"; then
			printf "Success! Updating status.\n"
			update_status_of_server_by_id "$id"
		else
			printf "Failed, deregistering.\n"
			deregister_server_by_id "$id" && printf "Done\n" || printf "Failed!\n"
		fi
	done

	if [[ $unhealthy_only == "true" ]]; then
		printf "Not checking servers marked healthy because we had too many unhealthy servers to check\n"
		return 0
	fi

	printf "Checking servers marked healthy...\n\n"

	for host in "${healthy_hosts[@]}"; do
		ids=(${host//%/ })
		name="${ids[0]}"
		ip="${ids[1]}"
		id="${ids[2]}"
		printf "Testing connectivity to healthy server %s... " "$name"
		if test_ssh_host "$ip"; then
			printf "Success!\n"
		else
			printf "Failed, updating status.\n"
			# As a safety precaution, we do not deregister servers marked healthy, we simply force a health check on them.
			# If the StrongDM server then marks them as unhealthy, we will clean them up next time.
			update_status_of_server_by_id "$id" && printf "Done\n" || printf "Failed!\n"
		fi
	done
}

sleeptime="${1:-300}"
i=0
while main; do
	let i+=1
	printf "Done with pass %d. Sleeping for %s\n" "$i" "$sleeptime"
	sleep "$sleeptime"
done
