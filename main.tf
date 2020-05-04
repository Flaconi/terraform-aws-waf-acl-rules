# For every rule with ranges set, create this rule with dynamic ip_set_descriptors
resource "aws_waf_ipset" "this" {
  for_each = { for rule in var.waf_rules : rule.name => rule if length(rule.ranges) > 0 }
  name     = each.key

  dynamic ip_set_descriptors {
    for_each = each.value.ranges
    content {
      type  = lookup(ip_set_descriptors.value, "type", "IPV4")
      value = ip_set_descriptors.value.value
    }
  }
}

# For every rule with ranges set, create this rule with dynamic ip_set_descriptors
resource "aws_waf_byte_match_set" "this" {
  for_each = { for rule in var.waf_rules : rule.name => rule if length(rule.byte_match_tuples) > 0 }
  name     = each.key

  dynamic byte_match_tuples {
    for_each = concat([], each.value.byte_match_tuples)
    content {
      text_transformation   = lookup(byte_match_tuples.value, "text_transformation", "NONE")
      positional_constraint = lookup(byte_match_tuples.value, "positional_constraint", "CONTAINS")
      target_string         = lookup(byte_match_tuples.value, "target_string")
      field_to_match {
        type = lookup(byte_match_tuples.value, "field_to_match_type", "HEADER")
        data = lookup(byte_match_tuples.value, "field_to_match_data")
      }
    }
  }
}

# For every rule with ranges set, create this rule with dynamic ip_set_descriptors
resource "aws_waf_byte_match_set" "uri" {
  for_each = { for rule in var.waf_rules : rule.name => rule if length(rule.uri_match) > 0 }
  name     = each.key

  dynamic byte_match_tuples {
    for_each = concat([], each.value.uri_match)
    content {
      text_transformation   = lookup(byte_match_tuples.value, "text_transformation", "NONE")
      positional_constraint = lookup(byte_match_tuples.value, "positional_constraint", "STARTS_WITH")
      target_string         = lookup(byte_match_tuples.value, "target_string")
      field_to_match {
        type = "URI"
        data = null
      }
    }
  }
}

# For every rule create a `aws_waf_rule` and link it to either an `aws_waf_ipset` or an `aws_waf_byte_match_set`
resource "aws_waf_rule" "this" {
  for_each    = { for rule in var.waf_rules : rule.name => rule }
  name        = each.key
  metric_name = each.key

  # IPSET Rules
  dynamic predicates {
    for_each = (length(each.value.ranges) > 0 ? [true] : [])
    content {
      data_id = aws_waf_ipset.this[each.key].id
      negated = each.value["negated"]
      type    = "IPMatch"
    }
  }

  # ByteMatch Rules
  dynamic predicates {
    for_each = (length(each.value.byte_match_tuples) > 0 ? [true] : [])
    content {
      data_id = aws_waf_byte_match_set.this[each.key].id
      negated = each.value["negated"]
      type    = "ByteMatch"
    }
  }

  # URI Match Rules
  dynamic predicates {
    for_each = (length(each.value.uri_match) > 0 ? [true] : [])
    content {
      data_id = aws_waf_byte_match_set.uri[each.key].id
      negated = false
      type    = "ByteMatch"
    }
  }
}


# Create an `aws_waf_web_acl` and attach all enabled rules to it.
resource "aws_waf_web_acl" "this" {
  name        = var.waf_acl_name
  metric_name = var.waf_acl_name

  default_action {
    type = var.waf_acl_default_action
  }

  dynamic rules {
    for_each = { for rule in var.waf_rules : rule.name => rule if rule.enabled }
    content {
      action {
        type = lookup(rules.value, "action_type", "ALLOW")
      }

      priority = rules.value.priority
      rule_id  = aws_waf_rule.this[rules.key].id
      type     = lookup(rules.value, "rules_type", "REGULAR")
    }
  }
}
