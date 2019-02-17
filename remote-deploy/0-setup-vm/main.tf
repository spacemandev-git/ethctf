module "project_id" {
  source = "DanielFallon/memorable-id/random"
  length = 30
}

resource "digitalocean_tag" "project" {
  name = "project:${module.project_id.memorable_id}"
}

resource "digitalocean_domain" "prefix" {
  name = "ethctf.fallon.io"
}