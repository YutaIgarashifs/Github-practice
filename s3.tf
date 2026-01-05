resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-igarashi-unique-name-123" 
  tags = { Name = "terraform-state-bucket" }
}