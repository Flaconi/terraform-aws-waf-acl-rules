output "this_aws_waf_acl_id" {
  value       = aws_waf_web_acl.this.id
  description = "waf acl id"
}
