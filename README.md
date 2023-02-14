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
      name         = "allowheaderx"
      priority     = "3"
      enabled      = true
      negated      = false
      action_type  = "ALLOW"
      ranges       = []
      byte_match_tuples = [{
        field_to_match_data = "header-X",
        target_string       = "containsthis"
      }]
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_waf_byte_match_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_byte_match_set) | resource |
| [aws_waf_byte_match_set.uri](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_byte_match_set) | resource |
| [aws_waf_ipset.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_ipset) | resource |
| [aws_waf_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule) | resource |
| [aws_waf_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_web_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_waf_rules"></a> [waf\_rules](#input\_waf\_rules) | Waf Rules | <pre>list(object({<br>    name              = string<br>    enabled           = bool<br>    priority          = string<br>    negated           = bool<br>    action_type       = string<br>    ranges            = list(map(string))<br>    byte_match_tuples = list(map(string))<br>    uri_match         = list(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_waf_acl_name"></a> [waf\_acl\_name](#input\_waf\_acl\_name) | Waf Rules | `string` | n/a | yes |
| <a name="input_waf_acl_default_action"></a> [waf\_acl\_default\_action](#input\_waf\_acl\_default\_action) | WAF Default Action | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_aws_waf_acl_id"></a> [this\_aws\_waf\_acl\_id](#output\_this\_aws\_waf\_acl\_id) | waf acl id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## License

[MIT](LICENSE)

Copyright (c) 2019 [Flaconi GmbH](https://github.com/Flaconi)
