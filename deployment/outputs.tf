################################################################################
                  #Outputs from Network module
################################################################################

output "availability_zones" {
  value       = data.aws_availability_zones.available.names
  description = "Zones in wich region will be deployment App"
 }

output vpc_id {
  value       = aws_vpc.demo_vpc.id
  description = "output for VPC"
}

output vpc_cidr {
  value       = aws_vpc.demo_vpc.cidr_block
  description = "output for VPC's CIDR_BLOCK"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.demo_internet_gate_way.id
  description = "Internet gateway"
}

output "public_subnets_id" {
  value       = aws_subnet.public[*].id
    description = "IDs of subnets with public access"
  }
output "subnets_available_zone" {
  value       = aws_subnet.public[*].availability_zone
    description = "Available zones of subnets with public access"
}

output "public_subnets_cidr_blok" {
  value       =  aws_subnet.public[*].cidr_block
  description = "CIDR_BLOCK of subnets with publuc access"
}

output "private_subnets_id" {
  value       = aws_subnet.private[*].id

    description = "IDs of subnets with private access"
}

output "private_subnets_cidr_blok" {
  value       =  aws_subnet.private[*].cidr_block
  description = "CIDR_BLOCK of subnets with private access"
}

output "APP_URL"{
  value = aws_alb.main.dns_name
}