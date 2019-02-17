resource "digitalocean_droplet" "deploy_service" {
  count = 1
  image              = "centos-7-x64"
  name               = "${module.project_id.memorable_id}.deploy-service"
  region             = "nyc1"
  size               = "s-4vcpu-8gb"
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.default.*.id}",
  ]

  tags = ["${digitalocean_tag.project.id}"]
}

resource "digitalocean_floating_ip" "deploy_service" {
  count = "${digitalocean_droplet.deploy_service.count}"
  depends_on = ["digitalocean_droplet.deploy_service"]
  region     = "nyc1"
  droplet_id = "${digitalocean_droplet.deploy_service.id}"
}

resource "digitalocean_record" "deploy_service_servers" {
  count = "${digitalocean_droplet.deploy_service.count}"
  domain = "${digitalocean_domain.prefix.name}"
  type   = "A"
  name   = "deploy-${count.index}"
  value  = "${digitalocean_floating_ip.deploy_service.ip_address}"
  ttl    = 300
}

resource "digitalocean_record" "deploy_service" {
  count = "${digitalocean_droplet.deploy_service.count}"
  domain = "${digitalocean_domain.prefix.name}"
  type   = "A"
  name   = "deploy"
  value  = "${digitalocean_floating_ip.deploy_service.ip_address}"
  ttl    = 300
}

locals {
  deploy_service_inventory = <<-EOT
[deployservice]
${join("\n",digitalocean_record.deploy_service_servers.*.fqdn)}

[deployservice:vars]
ansible_user=root
ansible_become=false
  EOT
}
