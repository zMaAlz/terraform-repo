resource "yandex_iam_service_account" "robot" {
  name        = "robot"
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = "${yandex_resourcemanager_folder.WORK_FOLDER.id}"
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.robot.id}",
  ]
}

output "service_account" {
  value = "${yandex_iam_service_account.robot.id} created"
}
