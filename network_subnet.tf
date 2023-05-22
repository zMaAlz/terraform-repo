resource "yandex_vpc_network" "lab-network" {
  name = "lab-network"
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
}
resource "yandex_vpc_route_table" "lab-route-table-private" {
  for_each = var.YC_ZONE_CIDR_NAT
  name = "lab-route-table-private-${each.key}"
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  network_id = "${yandex_vpc_network.lab-network.id}"
  
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${each.value.nat_instance_ip}"
  }
}
resource "yandex_vpc_subnet" "lab-subnet-public" {
  for_each = var.YC_ZONE_CIDR_NAT
  name = "lab-subnet-public-${each.key}"
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  network_id = "${yandex_vpc_network.lab-network.id}"
  zone = each.key
  v4_cidr_blocks = ["${each.value.subnet_public_cidr}"]
}
resource "yandex_vpc_subnet" "lab-subnet-private" {
  for_each = var.YC_ZONE_CIDR_NAT
  name = "lab-subnet-private-${each.key}"
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  network_id = "${yandex_vpc_network.lab-network.id}"
  zone = each.key
  v4_cidr_blocks = ["${each.value.subnet_private_cidr}"]
  route_table_id = "${yandex_vpc_route_table.lab-route-table-private[each.key].id}"
}
resource "yandex_vpc_address" "addr" {
  name = "public-ip"
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  external_ipv4_address {
    zone_id = var.YC_ACTIVE_ZONE
  }
}
resource "yandex_lb_network_load_balancer" "kube-lb" {
  name = "lb-kube-ingress"
  description = " load balancer ingress group "
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  listener {
    name = "web-to-ingress"
    port = 8081
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
      address = "${yandex_vpc_address.addr.external_ipv4_address.0.address}"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.kubeingress-group-lb.load_balancer.0.target_group_id}"
    healthcheck {
      name = "http"
      interval = 15
      timeout = 10
      http_options {
        port = 8081
        path = "/"
      }
    }
  }
}

output "external_ip_address" {
  value = "${yandex_vpc_address.addr.external_ipv4_address.0.address}"
}