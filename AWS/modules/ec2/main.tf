resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = var.instance_tag
  }

  user_data = var.user_data
}
