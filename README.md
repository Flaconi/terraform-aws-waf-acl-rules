# WAF ACL Rules

[![Build Status](https://travis-ci.com/Flaconi/terraform-aws-waf-acl-rules.svg?branch=master)](https://travis-ci.com/Flaconi/terraform-aws-waf-acl-rules)
[![Tag](https://img.shields.io/github/tag/Flaconi/terraform-aws-waf-acl-rules.svg)](https://github.com/Flaconi/terraform-aws-waf-acl-rules/releases)
<!-- [![Terraform](https://img.shields.io/badge/Terraform--registry-aws--iam--roles-brightgreen.svg)](https://registry.terraform.io/modules/Flaconi/waf-acl-rules/aws/) -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This Terraform module can create typical resources needed for using WAF

## Usage

### WAF ACL

```hcl
module "waf_acl_rules" {
  source = "github.com/flaconi/terraform-aws-waf-acl-rules"
  waf_acl_name           = "name"
  waf_acl_default_action = "BLOCK"
  waf_rules              = local.waf_rules
  waf_rules = [{
    name              = "name"
    priority          = "1"
    enabled           = false
    negated           = false
    action_type       = "ALLOW"
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
    negated           = true
    action_type       = "BLOCK"
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
      negated  = false
      ranges   = []
      byte_match_tuples = [{
        field_to_match_data = "header-X",
        target_string       = "containsthis"
      }]
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| waf\_acl\_default\_action | WAF Default Action | string | n/a | yes |
| waf\_acl\_name | Waf Rules | string | n/a | yes |
| waf\_rules | Waf Rules | object | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_aws\_waf\_acl\_id | waf acl id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## License

[MIT](LICENSE)

Copyright (c) 2019 [Flaconi GmbH](https://github.com/Flaconi)
