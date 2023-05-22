resource "yandex_compute_disk" "volume1" {
    size = 50   
    folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
    zone = var.YC_ACTIVE_ZONE
}
resource "yandex_compute_disk" "volume2" {
    size = 50 
    folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
    zone = var.YC_ACTIVE_ZONE
}
