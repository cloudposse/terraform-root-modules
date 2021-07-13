# Component: `spacelift`

This component is responsible for provisioning Spacelift.

## Usage

This component runs on Spacelift directly. It is _not_ configured to run with `atmos` and state is stored directly on Spacelift. See [Spacelift Overview](docs/spacelift-overview.md).

[`default.auto.tfvars`](default.auto.tfvars) contains the configuration values Spacelift will use to manage the workspaces.

## Prerequisites

### GitHub Integration

1. The GitHub owner will need to sign up for a [free trial of Spacelift](https://spacelift.io/free-trial.html)
2. Once an account is created take note of the URL - usually its `https://<GITHUBORG>.app.spacelift.io/`
3. Create a Login Policy

   - Click on Policies then Add Policy
   - Use the following policy and replace `GITHUBORG` with the GitHub Organization slug and DEV with the GitHub id for the Dev setting up the Spacelift module.

   ```rego
   package spacelift

   # See https://docs.spacelift.io/concepts/policy/login-policy for implementation details.
   # Note: Login policies don't affect GitHub organization or SSO admins.
   # Note 2: Enabling SSO requires that all users have an IdP (G Suite) account, so we'll just use
   #          GitHub authentication in the meantime while working with external collaborators.
   # Map session input data to human friendly variables to use in policy evaluation

   username	:= input.session.login
   member_of   := input.session.teams # Input is friendly name, e.g. "SRE" not "sre" or "@GITHUBORG/sre"
   GITHUBORG   := input.session.member # Is this user a member of the CUSTOMER GitHub org?

   # Define GitHub usernames of non-GITHUBORG org external collaborators with admin vs. user access
   admin_collaborators := { "DEV" }
   user_collaborators  := { "GITHUBORG" } # Using GITHUBORG as a placeholder to avoid empty set

   # Grant admin access to GITHUBORG org members in the CloudPosse group
   admin {
     GITHUBORG
     member_of[_] == "CloudPosse"
   }

   # Grant admin access to non-GITHUBORG org accounts in the admin_collaborators set
   admin {
     # not GITHUBORG
       admin_collaborators[username]
   }

   # Grant user access to GITHUBORG org members in the Developers group
   # allow {
   # 	GITHUBORG
   # 	member_of[_] == "Developers"
   # }

   # Grant user access to non-GITHUBORG org accounts in the user_collaborators set
   allow {
     not GITHUBORG
     user_collaborators[username]
   }

   # Deny access to any non-GITHUBORG org accounts who aren't defined in external collaborators sets
   deny {
     not GITHUBORG
     not user_collaborators[username]
       not admin_collaborators[username]
   }
   ```

## Spacelift Layout

[Runtime configuration](https://docs.spacelift.io/concepts/configuration/runtime-configuration) is an optional piece of setup that is applied to individual runs instead of being global to the stack. It's defined in `.spacelift/config.yml` YAML file at the root of your repository.

### Create Spacelift helper scripts

Create the following scripts in your infrastructure repo's `/rootfs/usr/local/bin/` folder and ensure they're mounted into your Geodesic container:

[spacelift-assume-role](./bin/spacelift-assume-role) enables assume role support.

[spacelift-tf-workspace](./bin/spacelift-tf-workspace) manages selecting or creating a terraform workspace; similar to how `atmos` manages workspaces during a Terraform run.

[spacelift-write-env](./bin/spacelift-write-env) writes the AWS environment variables to the `.env` file.

[spacelift-write-vars](./bin/spacelift-write-vars) writes the component config using `atmos` to the `spacelift.auto.tfvars.json` file.

**NOTE**: make sure they are all executable:

```bash
chmod +x rootfs/usr/local/bin/spacelift*
```

## Building Spacelift Resources

### Build a Spacelift AMI

**NOTE**: this won't be necessary for Kubernetes implementations once Spacelift adds support for Kubernetes worker pools.

1. Clone the following GitHub repository: `git clone git@github.com:spacelift-io/spacelift-worker-image.git`
1. Grab the latest AL2 AMI ID:
```bash
aws ec2 describe-images --region $YOUR_TARGET_REGION --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-2.0.202*-x86_64-gp2" --query 'sort_by(Images, &CreationDate)[-1]' | jq -r .ImageId
```
1. In the cloned repo, add a `default.hcl` file with the following content (replace anything in `<PLACEHOLDER>` with the specified value):
```hcl
base_ami = "<IMAGE_ID_FROM_ABOVE>" # ami-????????????
region = "<YOUR_TARGET_REGION>" # us-east-1, us-west-2, etc.
ami_regions = ["<YOUR_TARGET_REGION>"] # us-east-1, us-west-2, etc.
ami_groups = []
shared_credentials_file = "~/.aws/credentials"
additional_tags = {
  CreatedBy = "<YOUR_NAME>" # So someone can find you =)
}
```
1. Run `packer build -var-file=default.hcl .` against the account Spacelift will be deployed to
1. Take note of the AMI created and use it to configure the `spacelift-worker-pool` component

### Deploy the [`spacelift-worker-pool`](../spacelift-worker-pool) Component

See [`spacelift-worker-pool` README](../spacelift-worker-pool/README.md) for the configuration and deployment needs.

### Update `default.auto.tfvars` parameters in `spacelift`

1. `runner_image` = ECR location and tag of new Docker container
2. `git_repository` = Name of `infrastructure` repository
3. `git_branch` = Name of main/master branch
4. `worker_pool_id` = Output of running `spacelift-worker-pool` component

### Manually update Autoscaling Group settings

You will need to login to the account where Spacelift is deployed to and manually update the ASG to spin up an instance. This is set to 0 by default
