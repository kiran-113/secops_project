# Generate an RSA private key
resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

# Generate a random 6-digit suffix for key uniqueness
resource "random_string" "random_number" {
  length  = 6
  special = false
}

# AWS Key Pair
resource "aws_key_pair" "this" {
  key_name   = "my-ec2key-${random_string.random_number.result}"
  public_key = tls_private_key.oskey.public_key_openssh
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Jenkins + SonarQube EC2 Instance
resource "aws_instance" "jenkins_ec2" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.jenkins_sg.id]
  key_name      = aws_key_pair.this.key_name
  associate_public_ip_address = true
  availability_zone = "us-west-2a"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    Name = "Jenkins-Sonar-Server"
  }

  # SSH Connection Configuration
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.oskey.private_key_pem
    host        = self.public_ip
  }

  # File Provisioner - Upload setup script
  provisioner "file" {
    source      = "startup.sh"         # Ensure this script exists in the same directory
    destination = "/tmp/startup.sh"
  }

  # Remote Execution Provisioner - Run setup script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/startup.sh",
      "sudo /tmp/startup.sh"
    ]
  }

  depends_on = [aws_security_group.jenkins_sg]
}



# #key_par
# resource "tls_private_key" "oskey" {
#   algorithm = "RSA"
# }

# # Specify the desired length of the hexadecimal string
# resource "random_string" "random_number" {
#   length  = 6
#   special = false
# }
# # creates pem file locally
# # resource "local_file" "myterrakey" {
# #   content  = tls_private_key.oskey.private_key_pem
# #   filename = "${aws_key_pair.this.key_name}.pem"
# # }

# resource "aws_key_pair" "this" {
#   key_name   = "my-ec2key-${random_string.random_number.result}"
#   public_key = tls_private_key.oskey.public_key_openssh
# }

# data "aws_ami" "amzn-linux-2023-ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }
# }

# resource "aws_instance" "jenkins_ec2" {
#   ami           = data.aws_ami.amzn-linux-2023-ami.id
#   instance_type = var.instance_type
#   subnet_id     = aws_subnet.public_subnet.id
#   security_groups = [aws_security_group.jenkins_sg.id]
#   key_name      = aws_key_pair.this.key_name
#   associate_public_ip_address = true
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 20
#   }

#   user_data = file("startup.sh")  # Ensure the startup script is in the same directory

#   tags = {
#     Name = "Jenkins-Sonar-Server"
#   }
# depends_on = [ aws_security_group.jenkins_sg ]

# }

# resource "aws_instance" "myapp-server-1" {
#   ami                         = data.aws_ami.amzn-linux-2023-ami.id
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.this.key_name
#   subnet_id                   = aws_subnet.myapp-subnet-1.id
#   vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
#   availability_zone           = var.avail_zone
#   associate_public_ip_address = true
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 20
#   }
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = tls_private_key.oskey.private_key_pem
#     host        = self.public_ip
#   }

#   provisioner "file" {
#     source      = "jenkins-server-script.sh"
#     destination = "/tmp/jenkins-server-script.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod +x /tmp/jenkins-server-script.sh",
#       "sudo /tmp/jenkins-server-script.sh",
#       "sleep 10"
#     ]
#   }

#   tags = {
#     Name = "${var.env_prefix}-server"
#   }

# }
