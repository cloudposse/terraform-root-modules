variable "region" {
  type        = string
  description = "AWS Region"
}

variable "ssm_path_prefix" {
  type        = string
  default     = "/waf"
  description = "SSM path prefix (with leading but not trailing slash) under which to store all WAF info"
}

variable "acl_name" {
  type        = string
  description = "Friendly name of the ACL. The ACL ARN will be stored in SSM under {ssm_path_prefix}/{acl_name}/arn"
}

variable "default_action" {
  type        = string
  default     = "block"
  description = "Specifies that AWS WAF should allow requests by default. Possible values: `allow`, `block`."
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Allowed values: `allow`, `block`."
  }
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "A friendly description of the WebACL."
}

variable "scope" {
  type        = string
  default     = "REGIONAL"
  description = <<-DOC
    Specifies whether this is for an AWS CloudFront distribution or for a regional application.
    Possible values are `CLOUDFRONT` or `REGIONAL`.
    To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider.
  DOC
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "Allowed values: `CLOUDFRONT`, `REGIONAL`."
  }
}

variable "visibility_config" {
  type        = map(string)
  default     = {}
  description = <<-DOC
    Defines and enables Amazon CloudWatch metrics and web request sample collection.

    cloudwatch_metrics_enabled:
      Whether the associated resource sends metrics to CloudWatch.
    metric_name:
      A friendly name of the CloudWatch metric.
    sampled_requests_enabled:
      Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "byte_match_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement that defines a string match search for AWS WAF to apply to web requests.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      field_to_match:
        The part of a web request that you want AWS WAF to inspect.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match
      text_transformation:
        Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "geo_match_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement used to identify web requests based on country of origin.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      country_codes:
        A list of two-character country codes.
      forwarded_ip_config:
        fallback_behavior:
          The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.
          Possible values: `MATCH`, `NO_MATCH`
        header_name:
          The name of the HTTP header to use for the IP address.

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "ip_set_reference_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement used to detect web requests coming from particular IP addresses or address ranges.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      arn:
        The ARN of the IP Set that this statement references.
      ip_set_forwarded_ip_config:
        fallback_behavior:
          The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.
          Possible values: `MATCH`, `NO_MATCH`
        header_name:
          The name of the HTTP header to use for the IP address.
        position:
          The position in the header to search for the IP address.
          Possible values include: `FIRST`, `LAST`, or `ANY`.

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "managed_rule_group_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement used to run the rules that are defined in a managed rule group.

    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    override_action:
      The override action to apply to the rules in a rule group.
      Possible values: `count`, `none`

    statement:
      name:
        The name of the managed rule group.
      vendor_name:
        The name of the managed rule group vendor.
      excluded_rule:
        The list of names of the rules to exclude.

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "rate_based_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rate-based rule tracks the rate of requests for each originating IP address,
    and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      aggregate_key_type:
         Setting that indicates how to aggregate the request counts.
         Possible values include: `FORWARDED_IP` or `IP`
      limit:
        The limit on requests per 5-minute period for a single originating IP address.
      forwarded_ip_config:
        fallback_behavior:
          The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.
          Possible values: `MATCH`, `NO_MATCH`
        header_name:
          The name of the HTTP header to use for the IP address.

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "regex_pattern_set_reference_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement used to search web request components for matches with regular expressions.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      arn:
         The Amazon Resource Name (ARN) of the Regex Pattern Set that this statement references.
      field_to_match:
        The part of a web request that you want AWS WAF to inspect.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match
      text_transformation:
        Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "rule_group_reference_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement used to run the rules that are defined in an WAFv2 Rule Group.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    override_action:
      The override action to apply to the rules in a rule group.
      Possible values: `count`, `none`

    statement:
      arn:
        The ARN of the `aws_wafv2_rule_group` resource.
      excluded_rule:
        The list of names of the rules to exclude.

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "size_constraint_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement that uses a comparison operator to compare a number of bytes against the size of a request component.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      comparison_operator:
         The operator to use to compare the request part to the size setting.
         Possible values: `EQ`, `NE`, `LE`, `LT`, `GE`, or `GT`.
      size:
        The size, in bytes, to compare to the request part, after any transformations.
        Valid values are integers between `0` and `21474836480`, inclusive.
      field_to_match:
        The part of a web request that you want AWS WAF to inspect.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match
      text_transformation:
        Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "sqli_match_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    An SQL injection match condition identifies the part of web requests,
    such as the URI or the query string, that you want AWS WAF to inspect.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    statement:
      field_to_match:
        The part of a web request that you want AWS WAF to inspect.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match
      text_transformation:
        Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "xss_match_statement_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    A rule statement that defines a cross-site scripting (XSS) match search for AWS WAF to apply to web requests.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    xss_match_statement:
      field_to_match:
        The part of a web request that you want AWS WAF to inspect.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#field-to-match
      text_transformation:
        Text transformations eliminate some of the unusual formatting that attackers use in web requests in an effort to bypass detection.
        See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#text-transformation

    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}

variable "association_resource_arns" {
  type        = list(string)
  default     = []
  description = <<-DOC
    A list of ARNs of the resources to associate with the web ACL.
    This must be an ARN of an Application Load Balancer or an Amazon API Gateway stage.
  DOC
}

variable "log_destination_configs" {
  type        = list(string)
  default     = []
  description = "The Amazon Kinesis Data Firehose ARNs."
}

variable "redacted_fields" {
  type = object({
    method_enabled       = bool,
    uri_path_enabled     = bool,
    query_string_enabled = bool,
    single_header        = list(string)
  })
  default     = null
  description = <<-DOC
    The parts of the request that you want to keep out of the logs.

    method_enabled:
      Whether to enable redaction of the HTTP method.
      The method indicates the type of operation that the request is asking the origin to perform.
    uri_path_enabled:
      Whether to enable redaction of the URI path.
      This is the part of a web request that identifies a resource.
    query_string_enabled:
      Whether to enable redaction of the query string.
      This is the part of a URL that appears after a `?` character, if any.
    single_header:
      The list of names of the query headers to redact.
  DOC
}
