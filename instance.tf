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
      image_id = "fd8p2ku5ild2apkquv25"
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
resource "yandex_compute_instance" "ceph_instance" {
  name        = "ceph-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "ceph-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 4
    core_fraction = 20
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8a6oof3af7o2kpb6r4"
      size = 30
    }
  }
  secondary_disk {
    disk_id = "${yandex_compute_disk.volume1.id}"
    device_name = "ceph1"
  }
  secondary_disk {
    disk_id = "${yandex_compute_disk.volume2.id}"
    device_name = "ceph2"
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].ceph_instance_ip}"
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_CICD)}"
    }
  scheduling_policy {
    preemptible = true
  }  
}
resource "yandex_compute_instance" "gitlab_instance" {
  name        = "gitlab-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "gitlab-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 4
    core_fraction = 100
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = "fd8a6oof3af7o2kpb6r4"
      size = 60
      type = "network-ssd"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].gitlab_instance_ip}"
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_CICD)}"
    }
  scheduling_policy {
    preemptible = true
  }  
}
resource "yandex_compute_instance" "kubemaster_instance" {
  name        = "kubemaster-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "kubemaster-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 2
    core_fraction = 100
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8a6oof3af7o2kpb6r4"
      size = 50
      type = "network-ssd"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].kubemaster_instance_ip}"
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_KUBE)}"
    }
  scheduling_policy {
    preemptible = true
  }  
}
resource "yandex_compute_instance" "kubenode1_instance" {
  name        = "kubenode1-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "kubenode1-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 4
    core_fraction = 100
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = "fd8a6oof3af7o2kpb6r4"
      size = 50
      type = "network-ssd"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].kubenode1_instance_ip}"
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_KUBE)}"
    }
  scheduling_policy {
    preemptible = true
  }  
}
resource "yandex_compute_instance" "kubenode2_instance" {
  name        = "kubenode2-${var.YC_ACTIVE_ZONE}"
  folder_id   = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  hostname = "kubenode2-${var.YC_ACTIVE_ZONE}"
  platform_id = "standard-v1"
  zone        = var.YC_ACTIVE_ZONE
  resources {
    cores  = 4
    core_fraction = 100
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = "fd8a6oof3af7o2kpb6r4"
      size = 50
      type = "network-ssd"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private["${var.YC_ACTIVE_ZONE}"].id}"
    ip_address = "${var.YC_ZONE_CIDR_NAT["${var.YC_ACTIVE_ZONE}"].kubenode2_instance_ip}"
  }
    metadata = {
        user-data = "${file(var.YC_INSTANS_KUBE)}"
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
      core_fraction = 20
      memory = 4
    }
    boot_disk {
      initialize_params {
        image_id = "fd8a6oof3af7o2kpb6r4"
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
      size = 1
    }
  }
  allocation_policy {
    zones = ["${var.YC_ACTIVE_ZONE}"]
  }
  deploy_policy {
    max_expansion = 2
    max_unavailable = 1
    startup_duration = 120
  }
  load_balancer {
    target_group_name        = "kubeingress-group-lb"
    target_group_description = "ingress group for load balancer"
    target_group_labels = { 
      kube = "ingress"
    }  
    max_opening_traffic_duration = 1200
  }
}

output "instance_nat_ip_addr_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address}"
}
output "instance_ip_addr_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.ip_address}"
}
output "instance_ip_addr_gitlab_instance" {
  value = "${yandex_compute_instance.gitlab_instance.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubemaster_instance" {
  value = "${yandex_compute_instance.kubemaster_instance.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubenode1_instance" {
  value = "${yandex_compute_instance.kubenode1_instance.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubenode2_instance" {
  value = "${yandex_compute_instance.kubenode2_instance.network_interface.0.ip_address}"
}
output "instance_ip_addr_kubeingress-instance" {
  value = "${yandex_compute_instance_group.kubeingress-group-lb.instance_template.0.network_interface.0.ip_address}"
}
output "instance_ip_addr_ceph_instance" {
  value = "${yandex_compute_instance.ceph_instance.network_interface.0.ip_address}"
}
