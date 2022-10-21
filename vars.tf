variable "region" {
    default = "eu-west-1"
}

variable "profile" {
    default = "default"
}
variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}

variable "dnsHostNames" {
  default = true
}

variable "publicsubnetCIDRblock"{
    default = "10.0.0.0/24"
}


variable "destinationCIDRblock" {

  default = "0.0.0.0/0"
}

variable "ingressCIDRblockPub" {
  type    = string
  default = "0.0.0.0/0"
}

variable "mapPublicIP" {
    default = true
}

variable "availabilityZonePub" {
  default = "eu-west-1a"
}

variable "availabilityZonePriv1" {
  default = "eu-west-1b"
}

variable "availabilityZonePriv2" {
  default = "eu-west-1c"
}

variable "public_instance" {
    type=string
    default = "ami-0ea0f26a6d50850c5"
}

variable "key_name"{
    type    = string
    default = "endptkey"
}

variable "db_name" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
  
}

variable "private_subnet_cidrblock1" {
    default = "10.0.101.0/24"
}
variable "private_subnet_cidrblock2" {
    default = "10.0.102.0/24"
}