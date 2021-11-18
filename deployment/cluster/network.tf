
# Data source for declarate availability zones
data "aws_availability_zones" "available" {
  state = "available"
}


# Create Virual Private Cloud
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "My Demo VPC for ${var.app_name} ${var.env} vpc "
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

# Create  subnets with public access from pool CIDRs of private IPs VPC
 resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.demo_vpc.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.demo_vpc.id
  map_public_ip_on_launch = true
    tags = {
    Name = "Subnet in ${data.aws_availability_zones.available.names[count.index]} with public access  ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

# Create  subnets with private access from pool CIDRs of private IPs VPC
resource "aws_subnet" "private" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.demo_vpc.cidr_block, 8, var.az_count +  count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.demo_vpc.id
    tags = {
    Name = "Subnet in ${data.aws_availability_zones.available.names[count.index]} with private access  ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

# Create Internet Gateway for my VPC
resource "aws_internet_gateway" "demo_internet_gate_way" {
vpc_id = aws_vpc.demo_vpc.id
    tags = {
    Name = "Internet Gateway for ${var.app_name} ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.demo_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo_internet_gate_way.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gate_way" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.demo_internet_gate_way]
  tags = {
    Name = "Elastic IP for ${var.app_name} ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

resource "aws_nat_gateway" "gate_way" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gate_way.*.id, count.index)
  tags = {
    Name = "Gateway for ${var.app_name} ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gate_way.*.id, count.index)
  }
  tags = {
    Name = "Routing table for private subnets ${var.app_name} ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
