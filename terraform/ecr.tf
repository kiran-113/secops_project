resource "aws_ecr_repository" "foo" {
  name                 = "razorpay-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}