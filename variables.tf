variable "project" { # we will not give any default value to this variable because we want to make it mandatory for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
    type = string
}

variable "environment" { # we will not give any default value to this variable because we want to make it mandatory for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
    type = string
}

variable "cidr_block" { 
    type = string
    default = "10.0.0.0/16" # we are giving a default value to this variable because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "vpc_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "igw_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
  
}

variable "public_subnet_cidr" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
    type = list
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidr" {
    type = list
    default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "public_subnet_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}
variable "private_subnet_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "database_subnet_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "public_route_table_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "private_route_table_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "database_route_table_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "eip_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

variable "nat_gateway_tags" {
    type = map
    default = {} # we are making this variable default to an empty map because we want to make it optional for the user to provide a value for this variable. If we give a default value then it will not be mandatory for the user to provide a value for this variable.
}

