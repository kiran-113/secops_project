# Create IAM Role
resource "aws_iam_role" "ec2_full_access_role" {
  name = "ec2_full_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

# Attach Full Access Policy to the Role
resource "aws_iam_policy_attachment" "full_access" {
  name       = "attach_full_access"
  roles      = [aws_iam_role.ec2_full_access_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  #arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_full_access_instance_profile"
  role = aws_iam_role.ec2_full_access_role.name
}