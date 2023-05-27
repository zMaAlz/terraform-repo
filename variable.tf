variable "YC_TOKEN" {
  default = ""
}
variable "YC_CLOUD_ID" {
  default = ""
}
variable "YC_FOLDER_ID" {
  default = ""
}
variable "YC_WORK_FOLDER" {
  default = "stage-dev"
}
variable "YC_ACTIVE_ZONE" {
  default = "ru-central1-a"
}
variable "YC_DNS_ZONE" {
  default = "familym.ru"
}
variable "YC_ZONE_CIDR_NAT" {
  default = {
    "ru-central1-a" = { subnet_private_cidr = "192.168.2.0/24", subnet_public_cidr = "10.2.2.0/24", nat_instance_ip = "10.2.2.254", ceph_instance_ip = "192.168.2.200", gitlab_instance_ip = "192.168.2.210", kubemaster_instance_ip = "192.168.2.220" }
    "ru-central1-b" = { subnet_private_cidr = "192.168.3.0/24", subnet_public_cidr = "10.2.3.0/24", nat_instance_ip = "10.2.3.254", ceph_instance_ip = "192.168.3.200", gitlab_instance_ip = "192.168.3.210", kubemaster_instance_ip = "192.168.3.220" }
    }
}
variable "YC_INSTANS_NAT" {
  default = "conf/nat.yaml"
}
variable "YC_INSTANS_KUBE" {
  default = "conf/kubesrv.yaml"
}
variable "YC_INSTANS_CICD" {
  default = "conf/cicd.yaml"
}
