variable "vpc_cidr" {
    default = "10.0.0.0/16"  #user can override 
}

variable "enable_dns_hostnames" {
    type = bool
    default = true  
}

variable "common_tags" {
    type = map
    default = {} #its optional  
}

variable "vpc_tags" {
    type = map
    default = {} #its optional  
}

variable "project_name" {
    type = string
  
}
variable "environment" {
    type = string
  
}
variable "igw_tags" {
    type = map
    default = {}
  
}

variable "public-subnets-cidr" {
    type = list
  validation {
    condition = length(var.public-subnets-cidr) ==2
    error_message = "please give 2 valid public subnet cidr"
  }
}
variable "public-subnets_tags" {
    default = {}
  
}

variable "private-subnets-cidr" {
    type = list
  validation {
    condition = length(var.private-subnets-cidr) ==2
    error_message = "please give 2 valid private subnet cidr"
  }
}
variable "private-subnets_tags" {
    default = {}
  
}

variable "database-subnets-cidr" {
    type = list
  validation {
    condition = length(var.database-subnets-cidr) ==2
    error_message = "please give 2 valid database subnet cidr"
  }
}
variable "database-subnets_tags" {
    default = {}
  
}

variable "cidr_block" {
    default = {}
  
}

variable "nat_gateway_tag" {
    default = {}
  
}

variable "public_route_table_tags" {
    default = {}
  
}

variable "private_route_table_tags" {
    default = {}
  
}

variable "database_route_table_tags" {
    default = {}
  
}

variable "is_peering_required" {
    type = bool
    default = false
  
}

variable "acceptor_vpc_id" {
    default = ""
  
}

variable "vpc_peering_tags" {
    default = {}
  
}