output "ansible_inventory" {
  description = "An ansible_inventory file that describes the resources in the project."
  value = <<-EOT
  ${join("\n", list(
    local.deploy_service_inventory
  ))}
  EOT
}
