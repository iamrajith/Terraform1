provider "aws" {
  region = var.myregion
  access_key = var.myaccesskey
  secret_key = var.mysecretkey
}

variable "myregion" {
  description = "Your required region"
}

variable "myaccesskey" {
  description = "Your access key"
}

variable "mysecretkey" {
  description = "Your sec key"
}

variable "mycidr" {
    description = "CIDR for VPC"
    default = "100.100.0.0/16"
  
}

variable "mycidrsub" {
  description = "CIDR for subnet 1 "
  default = "100.100.1.0/24"
}

variable "mycidrsub2" {
  description = "CIDR for subnet 2 "
  default = "100.100.2.0/24"
}


resource "aws_vpc" "myvpc" {
  instance_tenancy = "default"
  cidr_block = var.mycidr
  tags = {
    Name = "Pavan-VPC"
   }
}

resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.mycidrsub
  availability_zone = "us-west-2a"
  tags = {
    Name = "Pavan-VPC-Subnet1"
   }
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "pavan-VPC-IGateway"
  }
}

resource "aws_route_table" "myroute1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "myroute1_association" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroute1.id
}

resource "aws_security_group" "mysg" {
  name        = "allow_ssh_http"
  description = "Allow ssh and http traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

######Add EBS volume 

resource "aws_ebs_volume" "disk1" {
  availability_zone = aws_instance.myvm1.availability_zone

  size              = 5

  tags = {
    Name = "disk1-for-vm1"
  }
}

#### 

resource "aws_instance" "myvm1" {
  ami = "ami-01450e8988a4e7f44"
  instance_type = "t2.micro"
  key_name = "testkey2"
  subnet_id = aws_subnet.mysubnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.mysg.id]
  availability_zone = "us-west-2a"

  tags = {
    Name = "Server1"
  }

}

resource "aws_instance" "myvm2" {
  ami = "ami-008fe2fc65df48dac"
  instance_type = "t2.micro"
  key_name = "testkey2"
  subnet_id = aws_subnet.mysubnet.id
  associate_public_ip_address = true
  availability_zone = "us-west-2a"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update
  sudo apt install apache2 -y
  sudo echo "Test server from myvm2" > /var/www/html/index.html
  sudo systemctl restart apache2
  sudo systemctl enable apach2
  EOF

  tags = {
    Name = "Server2"
  }

}

