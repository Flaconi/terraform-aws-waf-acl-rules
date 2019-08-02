#{
# 		name              = "name"
# 		priority          = "1"
# 		enabled           = false
# 		byte_match_tuples = []
# 		ranges = [
# 			{
# 				"value" = "127.0.0.1/32"
# 			},
# 		]
# 		}, {
# 		name              = "blockgoogle"
# 		priority          = "2"
# 		enabled           = true
# 		byte_match_tuples = []
# 		ranges = [
# 			{
# 				"value" = "8.8.4.4/32"
# 			},
# 			{
# 				"value" = "8.8.8.8/32"
# 			},
# 		]
# 	}]

variable "waf_rules" {
  description = "Waf Rules"
  #type        = any
  default = []
  type = list(object({
    name              = string
    enabled           = bool
    priority          = string
    ranges            = list(map(string))
    byte_match_tuples = list(map(string))
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
