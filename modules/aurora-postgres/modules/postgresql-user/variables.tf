variable "enabled" {
  type        = bool
  default     = true
  description = "Set false to prevent creation of resources"
}

variable "service_name" {
  type        = string
  description = "Name of service owning the database (used in SSM key)"
}

variable "db_user" {
  type        = string
  description = "PostgreSQL user name to create (default is service name)"
  default     = ""
}

variable "db_password" {
  type        = string
  description = "PostgreSQL password created user (generated if not provided)"
  default     = ""
}

variable "grants" {
  type = list(object({
    grant : list(string)
    db : string
    schema : string
    object_type : string
  }))
  description = <<-EOT
    List of { grant: [<grant>, <grant>, ...], db: "db", schema: null, object_type: "database"}.
    EOT
  default     = [{ grant : ["ALL"], db : "*", schema : null, object_type : "database" }]
}

variable "ssm_path_prefix" {
  type        = string
  default     = "aurora-postgres"
  description = "SSM path prefix (with leading but not trailing slash, e.g. \"/rds/cluster_name\")"
}
