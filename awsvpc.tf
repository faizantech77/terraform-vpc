provider "aws" {
  region = "us-east-1"
}
 
resource "aws_vpc" "main_vpc" {
  cidr_block = "172.55.0.0/16"
  tags = {
    Name = "terraformvpc"
  }
}

 
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "172.55.1.0/24"
  availability_zone = "us-east-1a"
   tags = {
    Name = "public-subnet"
  }
}
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

tags = {
    Name = "myinternetgateway"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}
 
resource "aws_route_table_association" "main_route_table_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id
 


 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "my_ec2" {
  ami           = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 
  tags = {
    Name = "Terraform-EC2"
  }
}
 

 


