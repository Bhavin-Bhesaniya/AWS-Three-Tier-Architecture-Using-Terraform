resource "aws_vpc" "three-tier-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default" # Instance Tenancy attributes Determines whether instances that are launched into this VPC are multi-tenant (shared) or single-tenant (dedicated).
  enable_dns_hostnames = true

  tags = {
    Name = "aws_vpc",
  }
}

resource "aws_subnet" "subnets" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = count.index < 2 ? true : false
}


# # # # # # # # # # #
# Internet Gateway  #
# # # # # # # # # # #
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three-tier-vpc.id
  tags = {
    Name = "aws_vpc_igw",
  }
}

resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.three-tier-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "Public-Route-Table" {
  count          = 2
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.Public-Route-Table.id
}


# # # # # # # # # 
# Nat Gateway   #
# # # # # # # # # 
resource "aws_eip" "nat_gw" {
  tags = {
    Name = "Nat gateway"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.subnets[0].id
  tags = {
    Name = "Nat1"
  }
}

# # # # # # # # # # # #
# Private Route - App #
# # # # # # # # # # # #
resource "aws_route_table" "Private-Route-Table" {
  vpc_id = aws_vpc.three-tier-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "Private-Route-Table" {
  count          = 4
  subnet_id      = aws_subnet.subnets[count.index + 2].id
  route_table_id = aws_route_table.Private-Route-Table.id
}
