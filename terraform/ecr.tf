resource "aws_ecr_repository" "flask_app" {
  name = "flask-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Application = "flask"
    Terraform   = "true"
  }
}
