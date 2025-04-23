

# создаем юзера, назначаем права 

resource "yandex_iam_service_account" "bucket_admin" {
  name        = "sa-s3bucket"
  description = "Temp"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id   = var.folder_id
  role        = "editor"
  member      = "serviceAccount:${yandex_iam_service_account.bucket_admin.id}"
}

# создаем ключ для доступа. хранится в state-файле
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
 service_account_id = yandex_iam_service_account.bucket_admin.id
 description        = "static access key for object storage"
# не шифруем
# pgp_key            = "keybase:keybaseusername"
 }

# создаем kms ключ
 resource "yandex_kms_symmetric_key" "key-a" {
  name              = "example-symetric-key"
  description       = "description for key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

# создаем корзину. внимание! Иногда сервисные аккаунты требуют дополнительного времени на  активацию (особенно если они только что созданы). мне пришлось подождать 1-2 минуты несмотря на то что все было правильно.
resource "yandex_storage_bucket" "bucket_net" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "temp-bucket"
    acl    = "public-read"

# добавляем шифрование
    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# перемещаем изображение
resource "yandex_storage_object" "image" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = yandex_storage_bucket.bucket_net.bucket
    key    = "image.jpg"
    source = "./image.jpg"
    acl    = "public-read"
}