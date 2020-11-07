
# Bucket origin
resource "aws_s3_bucket" "bucket" {
  bucket = var.name

  depends_on = [aws_s3_bucket.destination[0]]

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = var.lifecycle_enabled

    expiration {
      days                         = var.curr_obj_expiration
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = var.noncurr_obj_expiration
    }
  }

  policy = var.policy

  dynamic "replication_configuration" {
    for_each = var.name_replication == "" ? [] : [1]
    content {
      role = aws_iam_role.replication[0].arn

      rules {
        status = "Enabled"

        destination {
          bucket        = aws_s3_bucket.destination[0].arn
          storage_class = "STANDARD"
        }
      }
    }
  }

}


# Bucket replication (backup)
resource "aws_s3_bucket" "destination" {
  count = var.name_replication == "" ? 0 : 1

  bucket = var.name_replication

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days                         = var.replication_curr_obj_expiration
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = var.replication_noncurr_obj_expiration
    }
  }

}
