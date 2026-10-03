resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy = "default"
  #enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    var.vpc_tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # Links the IGW to your VPC

  tags = merge(
    var.igw_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr) # Creates a subnet for each CIDR block in the list     
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index] # Assigns each subnet to a different AZ 
  map_public_ip_on_launch = true # Automatically assigns public IPs to resources inside

  tags = merge(
    var.public_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-public-${split("-", local.az_names[count.index])[2]}" #splits the AZ name to get the last part of the AZ name and appends it to the subnet name
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr) # Creates a subnet for each CIDR block in the list     
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index] # Assigns each subnet to a different AZ 
  map_public_ip_on_launch = false # Does not automatically assign public IPs to resources inside

  tags = merge(
    var.private_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-private-${split("-", local.az_names[count.index])[2]}" #splits the AZ name to get the last part of the AZ name and appends it to the subnet name
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr) # Creates a subnet for each CIDR block in the list     
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index] # Assigns each subnet to a different AZ 
  map_public_ip_on_launch = false # Does not automatically assign public IPs to resources inside

  tags = merge(
    var.database_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-database-${split("-", local.az_names[count.index])[2]}" #splits the AZ name to get the last part of the AZ name and appends it to the subnet name
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.database_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.private_route_table_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.database_route_table_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-database"
    }
  )
}

# Create the association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr) # Creates an association for each public subnet
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr) # Creates an association for each private subnet
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr) # Creates an association for each database subnet
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

# Allocate the Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc" # Required for VPC resources

  tags = merge(
    var.eip_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-nat"
    }
  )
}

# Example usage: Attaching the EIP to a NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id # Maps the EIP to the NAT Gateway
  subnet_id     = aws_subnet.public[0].id
    tags = merge(
        var.nat_gateway_tags,
        local.common_tags,
    )
    depends_on = [aws_internet_gateway.main] # Ensures the IGW is created before the NAT Gateway
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}


resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

