name = "pg"

deletion_protection = true

storage_encrypted = true

engine = "aurora-postgresql"

engine_mode = "provisioned"

# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Updates.20180305.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.PostgreSQL.html
# aws rds describe-db-engine-versions  --engine aurora-postgresql
# If you know the engine version (example here is "12.4"), use Engine and DBParameterGroupFamily from:
#    aws rds describe-db-engine-versions --query "DBEngineVersions[]" | \
#    jq '.[] | select(.EngineVersion == "12.4") |
#       { Engine: .Engine, EngineVersion: .EngineVersion, DBParameterGroupFamily: .DBParameterGroupFamily }'
# For Aurora Postgres 12.4:
# engine: "postgresql"
# cluster_family: "aurora-postgresql12"
engine_version = "12.4"

cluster_family = "aurora-postgresql12"

database_name = ""

admin_user = ""

admin_password = ""

iam_database_authentication_enabled = false
