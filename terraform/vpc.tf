
resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public_subnet" {
  availability_zone = "us-west-2a"
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.jenkins_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_default_route_table.main-rtb.id
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.jenkins_vpc.id
  name   = "Jenkins-SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





# resource "aws_vpc" "myapp-vpc" {
#   cidr_block = var.vpc_cidr_block
#   tags = {
#     Name = "${var.env_prefix}-vpc"
#   }
# }

# resource "aws_subnet" "myapp-subnet-1" {
#   vpc_id            = aws_vpc.myapp-vpc.id
#   cidr_block        = var.subnet_cidr_block
#   availability_zone = var.avail_zone
#   tags = {
#     Name = "${var.env_prefix}-subnet-1"
#   }
# }

# resource "aws_internet_gateway" "myapp-igw" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   tags = {
#     Name = "${var.env_prefix}-igw"
#   }
# }

# resource "aws_default_route_table" "main-rtb" {
#   default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
#   tags = {
#     Name = "${var.env_prefix}-main-rtb"
#   }
# }

# resource "aws_route_table_association" "subnet-association" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_default_route_table.main-rtb.id
# }

# resource "aws_default_security_group" "default-sg" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 9000
#     to_port     = 9000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 8090
#     to_port     = 8090
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${var.env_prefix}-default-sg"
#   }
# }
