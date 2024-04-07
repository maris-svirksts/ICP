resource "aws_efs_file_system" "webserver_files" {
  creation_token = "web-server-data"

  tags = {
    Name = "Webserver files."
  }
}

resource "aws_efs_mount_target" "mount_target" {
  for_each        = toset(var.public_subnets)
  file_system_id  = aws_efs_file_system.webserver_files.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}
