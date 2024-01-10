output "azs" {
  value = data.aws_availability_zones.azs.names
  
}

output "vpc_id" {
  value = aws_vpc.main.id
  
}

output "public_id" {
  value = aws_subnet.public-subnet[*].id
  
}

output "private_id" {
  value = aws_subnet.private-subnet[*].id
  
}
output "database_id" {
  value = aws_subnet.database-subnet[*].id
  
}
