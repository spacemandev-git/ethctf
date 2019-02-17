locals {
  key_names = [
    "dfallon",
    "dbharel",
    "jearls",
  ]
}

resource "digitalocean_ssh_key" "default" {
  count      = "${length(local.key_names)}"
  name       = "${element(local.key_names, count.index)}"
  public_key = "${file("${path.module}/keys/${element(local.key_names, count.index)}.pub")}"
}
