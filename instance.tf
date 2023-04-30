resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "nat-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 2
    core_fraction = 5
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-public["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].nat_instance_ip}"
    nat = true
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_NAT)}"
    }
  scheduling_policy {
    preemptible = true
  }  
}
# resource "yandex_compute_instance" "cicd-instance" {
#   name        = "cicd-${var.YC_ACTIVE_ZONE}"
#   folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
#   hostname = "cicd-${var.YC_ACTIVE_ZONE}"
#   platform_id = "standard-v1"
#   zone        = var.YC_ACTIVE_ZONE
#   resources {
#     cores  = 4
#     core_fraction = 5
#     memory = 4
#   }
#   boot_disk {
#     initialize_params {
#       image_id = "fd80l3igojs610mh1ndg"
#     }
#   }
#   network_interface {
#     subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
#     ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].cicd_instance_ip}"
#   }
#     metadata = {
#         user-data = "${file(var.YC_INSTANS_CICD)}"
#     }
#   scheduling_policy {
#     preemptible = true
#   }  
# }
resource "yandex_compute_instance" "loadbalancer-instance" {
  name        = "loadbalancer-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "lb-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 4
    core_fraction = 10
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd80l3igojs610mh1ndg"
    }
  }
  secondary_disk {
    disk_id = "${yandex_compute_disk.volume1.id}"
    device_name = "/dev/sdb"
  }
  secondary_disk {
    disk_id = "${yandex_compute_disk.volume2.id}"
    device_name = "/dev/sdc"
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].lb_instance_ip}"
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_CICD)}"
    }
  scheduling_policy {
    preemptible = true
  }  
}
resource "yandex_compute_instance_group" "kubeingress-group-lb" {
  name               = "kubeingress-group-lb"
  folder_id          = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  service_account_id = "${yandex_iam_service_account.robot.id}"
  instance_template {  
    name = "kubeingress-{instance.index}"
    hostname = "kubeingress-{instance.index}"
    labels = { 
      kube = "ingress"
    }
    platform_id = "standard-v1"
    resources {
      cores  = 2
      core_fraction = 5
      memory = 2
    }
    boot_disk {
      initialize_params {
        image_id = "fd80l3igojs610mh1ndg"
        size = 20
      }
    }
    network_interface {
      network_id =  "${yandex_vpc_network.lab-network.id}"
      subnet_ids = ["${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"]
    }
    metadata = {
        user-data = "${file(var.YC_INSTANS_KUBE)}"
    }
    scheduling_policy {
      preemptible = true
    }    
  }
  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  allocation_policy {
    zones = ["${var.YC_ACTIVE_ZONE}"]
  }
  deploy_policy {
    max_expansion = 2
    max_unavailable = 1
    startup_duration = 60
  }
  load_balancer {
    target_group_name        = "kubeingress-group-lb"
    target_group_description = "ingress group for load balancer"
    target_group_labels = { 
      kube = "ingress"
    }  
    max_opening_traffic_duration = 120
  }
}
resource "yandex_compute_instance_group" "kubemaster-group" {
  name               = "kubemaster-group"
  folder_id          = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  service_account_id = "${yandex_iam_service_account.robot.id}"
  instance_template {
    name = "kubemaster-{instance.index}"
    hostname = "kubemaster-{instance.index}"
    labels = { 
      kube = "master"
    }
    platform_id = "standard-v1"
    resources {
      cores  = 2
      core_fraction = 10
      memory = 4
    }
    boot_disk {
      initialize_params {
        image_id = "fd80l3igojs610mh1ndg"
        size = 50
      }
    }
    network_interface {
      network_id =  "${yandex_vpc_network.lab-network.id}"
      subnet_ids = ["${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"]
    }
    metadata = {
        user-data = "${file(var.YC_INSTANS_KUBE)}"
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = ["${var.YC_ACTIVE_ZONE}"]
  }
  deploy_policy {
    max_expansion = 3
    max_unavailable = 1
    startup_duration = 60
    strategy = "opportunistic"
  }
}
resource "yandex_compute_instance_group" "kubenodes-group" {
  name               = "kubenodes-group"
  folder_id          = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  service_account_id = "${yandex_iam_service_account.robot.id}"
  instance_template {
    name = "kubenodes-{instance.index}"
    hostname = "kubenodes-{instance.index}"
    labels = {
      kube = "nodes"
    }
    platform_id = "standard-v1"
    resources {
      cores  = 2
      core_fraction = 5
      memory = 4
    }
    boot_disk {
      initialize_params {
        image_id = "fd80l3igojs610mh1ndg"
        size = 60
      }
    }
    network_interface {
      network_id =  "${yandex_vpc_network.lab-network.id}"
      subnet_ids = ["${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"]
    }
    metadata = {
        user-data = "${file(var.YC_INSTANS_KUBE)}"
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  allocation_policy {
    zones = ["${var.YC_ACTIVE_ZONE}"]
  }
  deploy_policy {
    max_expansion = 2
    max_unavailable = 1
    startup_duration = 60
  }
}

output "instance_nat_ip_addr_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address}"
}
output "instance_ip_addr_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.ip_address}"
}
# output "instance_ip_addr_cicd-instance" {
#   value = "${yandex_compute_instance.cicd-instance.network_interface.0.ip_address}"
# }
output "instance_ip_addr_lb-instance" {
  value = "${yandex_compute_instance.loadbalancer-instance.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubenodes-instance" {
  value = "${yandex_compute_instance_group.kubenodes-group.instance_template.0.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubemaster-instance" {
  value = "${yandex_compute_instance_group.kubemaster-group.instance_template.0.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubeingress-instance" {
  value = "${yandex_compute_instance_group.kubeingress-group-lb.instance_template.0.network_interface.0.ip_address}"
}