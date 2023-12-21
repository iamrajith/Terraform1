
provider "aws" {
  region = var.myregion
  access_key = var.myaccesskey
  secret_key = var.mysecretkey
}

resource "aws_vpc" "myvpc" {
  instance_tenancy = "default"
  cidr_block = var.mycidr
  tags = {
    Name = "Rajith-VPC"
   }
}

resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.mycidrsub1
  tags = {
    Name = "Rajith-VPC-Subnet1"
   }
}

resource "aws_subnet" "mysubnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.mycidrsub2
  availability_zone = "us-west-2a"
  tags = {
    Name = "Rajith-VPC-Subnet2"
   }
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Rajith-VPC-IGateway"
  }
}


resource "aws_vpc" "myvpc1" {
  count = 3
  instance_tenancy = "default"
  cidr_block = "100.${count.index+1}.0.0/16"
  tags = {
    Name = "TestVPC${count.index+1}"
   }
}

