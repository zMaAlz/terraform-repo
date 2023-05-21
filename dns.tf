resource "yandex_dns_zone" "zone1" {
  name        = "zone-ru"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  description = "${var.YC_DNS_ZONE} public zone"

  zone             = "${var.YC_DNS_ZONE}."
  public           = true
}
resource "yandex_dns_recordset" "rs1" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = var.YC_DNS_ZONE
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs2" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "appchart.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs3" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "grafana.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs4" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "prometheus.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs5" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "alertmanager.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs6" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "node-exporter.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs7" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "atlantis.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
resource "yandex_dns_recordset" "rs8" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "gitlab.${var.YC_DNS_ZONE}"
  type    = "A"
  ttl     = 200
  data    = "${yandex_vpc_address.addr.ip}"
}
