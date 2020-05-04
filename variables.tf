variable "waf_rules" {
  description = "Waf Rules"
  default     = []
  type = list(object({
    name              = string
    enabled           = bool
    priority          = string
    negated           = bool
    ranges            = list(map(string))
    byte_match_tuples = list(map(string))
    uri_match         = list(map(string))
  }))
}

variable "waf_acl_name" {
  description = "Waf Rules"
  type        = string
}

variable "waf_acl_default_action" {
  description = "WAF Default Action"
  type        = string
}
