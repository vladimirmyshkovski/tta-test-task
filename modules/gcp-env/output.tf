output "service_account_name" {
  description = "value"
  value       = kubernetes_service_account.default.metadata[0].name
}

output "config_map_key_ref_name" {
  description = "value"
  value       = kubernetes_config_map.default.metadata[0].name
}
