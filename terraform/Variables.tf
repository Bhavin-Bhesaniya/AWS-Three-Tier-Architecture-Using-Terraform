variable "az" {
  default     = "ap-south-1"
  description = "The AWS region to deploy resources"
  type        = string
}

variable "azs" {
  default     = ["ap-south-1a", "ap-south-1b"]
  description = "The AWS availability zones to deploy resources"
  # type        = list(string)
}


variable "image_id" {
  default     = "ami-03f4878755434977f"
  description = "AMI image"
  type        = string
}

variable "instanance_type" {
  default     = "t2.micro"
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "ec2_key_name" {
  default     = "EC2-Three-Tier-Key-Pair"
  description = "The key pair name for the EC2 instance"
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}


variable "database-instance-class" {
  default     = "db.t2.micro"
  description = "The instance type for the RDS instance"
  type        = string
}