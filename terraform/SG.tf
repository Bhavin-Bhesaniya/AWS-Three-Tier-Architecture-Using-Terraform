# # # # # # # # # # # # # # # # # # # 
# SG For Application Load Balancer  # 
# # # # # # # # # # # # # # # # # # #

resource "aws_security_group" "alb_security_group" {
  name        = "ALB Security Group"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.three-tier-vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPs traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }
}

# # # # # # # # # # # # # # # # # # # # # # 
# SG For Application Tier (Bastion-Host)  # 
# # # # # # # # # # # # # # # # # # # # # # 

resource "aws_security_group" "webserver_security_group" {
  name        = "Web Server Security Group"
  description = "Allow HTTp/HTTPS and SSH traffic via ALB and SSH SG"
  vpc_id      = aws_vpc.three-tier-vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPs traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server Security Group"
  }
}


# # # # # # # # # # # # # # #
# SG For Presentation Tier  # 
# # # # # # # # # # # # # # #
resource "aws_security_group" "ssh_security_group" {
  name        = "SSH Access"
  description = "Allow SSH traffic for bastion host"
  vpc_id      = aws_vpc.three-tier-vpc.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnets[0].cidr_block, aws_subnet.subnets[1].cidr_block, aws_subnet.subnets[2].cidr_block, aws_subnet.subnets[3].cidr_block]
  }

  ingress {
    description = "Flask Access"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnets[0].cidr_block, aws_subnet.subnets[1].cidr_block, aws_subnet.subnets[2].cidr_block, aws_subnet.subnets[3].cidr_block]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}
# # # # # # # # # # # # #
# SG For Database Tier  #
# # # # # # # # # # # # # 
resource "aws_security_group" "db_security_group" {
  name        = "Database Access"
  description = "Enable MySQL Access on Port 3306"
  vpc_id      = aws_vpc.three-tier-vpc.id

  ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks = [aws_subnet.DB-Private-Subnet-1.cidr_block, aws_subnet.DB-Private-Subnet-2.cidr_block, aws_subnet.App-Private-Subnet-1.cidr_block, aws_subnet.App-Private-Subnet-2.cidr_block]
    cidr_blocks = [aws_subnet.subnets[4].cidr_block, aws_subnet.subnets[5].cidr_block, aws_subnet.subnets[2].cidr_block, aws_subnet.subnets[3].cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
  }
}
