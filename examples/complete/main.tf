provider "aws" {
  region = "us-east-1"
}

locals {
  waf_rules = [{
    name              = "name"
    priority          = "1"
    enabled           = false
    byte_match_tuples = []
    ranges = [
      {
        "value" = "127.0.0.1/32"
      },
    ]
    }, {
    name              = "blockgoogle"
    priority          = "2"
    enabled           = true
    byte_match_tuples = []
    ranges = [
      {
        "value" = "8.8.4.4/32"
      },
      {
        "value" = "8.8.8.8/32"
      },
    ]
    }
    , {
      name     = "allowheaderx"
      priority = "3"
      enabled  = true
      ranges   = []
      byte_match_tuples = [{
        field_to_match_data = "header-X",
        target_string       = "containsthis"
      }]
    }
  ]
}


module "waf_rules" {
  source                 = "../.."
  waf_acl_name           = "name"
  waf_rules              = local.waf_rules
  waf_acl_default_action = "BLOCK"
}

output "waf_acl_id" {
  value = module.waf_rules.this_aws_waf_acl_id
}
