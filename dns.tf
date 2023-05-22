resource "yandex_dns_zone" "zone1" {
  name        = "zone-ru"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  description = "${var.YC_DNS_ZONE} public zone"

  zone             = "${var.YC_DNS_ZONE}."
  public           = true
}
resource "yandex_dns_recordset" "rs1" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "gitlab"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
resource "yandex_dns_recordset" "rs2" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "appchart"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
resource "yandex_dns_recordset" "rs3" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "grafana"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
resource "yandex_dns_recordset" "rs4" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "prometheus"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
resource "yandex_dns_recordset" "rs5" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "alertmanager"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
resource "yandex_dns_recordset" "rs6" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "node-exporter"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
resource "yandex_dns_recordset" "rs7" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "atlantis"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr.external_ipv4_address.0.address}"]
}
