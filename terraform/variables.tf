variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    default     = "10.0.0.0/16"
}

variable "region" {
    description = "AWS region"
    default     = "us-west-2"

}

variable "env_prefix" {
    description = "Deployment environment"
    default     = "dev"
}
variable "instance_type" {
    description = "AWS instance type"
    default     = "t2.medium"
}

