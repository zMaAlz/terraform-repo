terraform { 
  required_providers { 
    yandex = { 
      source = "yandex-cloud/yandex"     
    } 
  }
  required_version = ">= 0.13"           

  backend "s3" {                             
    endpoint   = "storage.yandexcloud.net" 
    bucket     = "terabak" 
    region     = "ru-central1" 
    key        = "terraform.tfstate" 
    skip_region_validation      = true 
    skip_credentials_validation = true 
    } 
}

provider "yandex" {
  token = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}

resource "yandex_resourcemanager_folder" "WORK_FOLDER" {
  cloud_id    = var.YC_CLOUD_ID
  name        = var.YC_WORK_FOLDER
  description = var.YC_WORK_FOLDER
}

output "yandex_resourcemanager_folder_WORK_FOLDER" {
  value = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
}
