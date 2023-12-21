variable "myregion" {
  description = "Your required aws region"
}

variable "myaccesskey" {
  description = "Your IAM access key"
}

variable "mysecretkey" {
    description = "Your SEC key"
  
}

variable "mycidr" {
    description = "CIDR for VPC"
    default = "100.100.0.0/16"
  
}

variable "mycidrsub1" {
  description = "CIDR for subnet 1 "
  default = "100.100.1.0/24"
}

variable "mycidrsub2" {
  description = "CIDR for subnet 2 "
  default = "100.100.2.0/24"
}

