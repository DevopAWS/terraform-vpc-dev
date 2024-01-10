resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.common_tags,
  var.vpc_tags,
   {
    Name = local.name
  }
  )
}

#internet gateway igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
        Name = local.name
    }
  )
}

#public-subnet creation
resource "aws_subnet" "public-subnet" {
    count = length(var.public-subnets-cidr) 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public-subnets-cidr[count.index]
  availability_zone = local.azs_name[count.index]

  tags = merge(
    var.common_tags,
    var.public-subnets_tags,
    {
        Name = "${local.name}-public-subnet-${local.azs_name[count.index]}"
    }

  )
}

#private-subnet creation
resource "aws_subnet" "private-subnet" {
    count = length(var.private-subnets-cidr) 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private-subnets-cidr[count.index]
  availability_zone = local.azs_name[count.index]

  tags = merge(
    var.common_tags,
    var.private-subnets_tags,
    {
        Name = "${local.name}-private-subnet-${local.azs_name[count.index]}"
    }

  )
}

#database-subnet creation
resource "aws_subnet" "database-subnet" {
    count = length(var.database-subnets-cidr) 
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database-subnets-cidr[count.index]
  availability_zone = local.azs_name[count.index]

  tags = merge(
    var.common_tags,
    var.database-subnets_tags,
    {
        Name = "${local.name}-database-subnet-${local.azs_name[count.index]}"
    }

  )
}

#for rds group
resource "aws_db_subnet_group" "default" {
  name       = "${local.name}"
  subnet_ids = aws_subnet.database-subnet[*].id

  tags = {
    Name = "${local.name}"
  }
}

#create elastic ip
resource "aws_eip" "eip" {
  domain           = "vpc"
  
}

#create NAT gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet[0].id

  tags = merge(
    var.common_tags,
    var.nat_gateway_tag,
    {
      Name = "${local.name}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#create public-Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
      Name = "${local.name}-public"
    }
  )
}

#create private-Route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
      Name = "${local.name}-private"
    }
  )
}

#create database-Route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
      Name = "${local.name}-database"
    }
  )
}

#added routes into public-route-table
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
 
}

#added routes into private-route-table
resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
 
}

#added routes into database-route-table
resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
 
}

#public-subnet routetable association
resource "aws_route_table_association" "public" {
  count = length(var.public-subnets-cidr)
  subnet_id      = element(aws_subnet.public-subnet[*].id,count.index)
  route_table_id = aws_route_table.public.id
}

#private-subnet routetable association
resource "aws_route_table_association" "private" {
  count = length(var.private-subnets-cidr)
  subnet_id      = element(aws_subnet.private-subnet[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

#database-subnet routetable association
resource "aws_route_table_association" "database" {
  count = length(var.database-subnets-cidr)
  subnet_id      = element(aws_subnet.database-subnet[*].id,count.index)
  route_table_id = aws_route_table.database.id
}
