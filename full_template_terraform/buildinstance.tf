provider "aws" {
  region = "us-east-2"
}
#------Create AWS instance----------------
resource "aws_instance" "my_webserver" {
    ami = "ami-00c03f7f7f2ec15c3"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.terraform-subnet.id}"
    key_name = "vitalii"
    security_groups = ["${aws_security_group.terraform_sg.id}"]
    user_data = <<EOF
    #!/bin/bash
    sudo yum -y install httpd
    echo "<h2>Webserver made by Terraform !" > /var/www/html/index.html
    sudo service httpd start
    chkonfig httpd on
    EOF

    tags = {
        Name = "vitalii-terraform-test"
    }
}
#-------Asign elastic IP-------------------
resource "aws_eip" "my_eip" {
  vpc = true
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.my_webserver.id}"
  allocation_id = "${aws_eip.my_eip.id}"
}

#-------Specificate before created VPC-------
resource "aws_vpc" "vitalii-terraform-vpc" {
    cidr_block = "10.100.0.0/16"  
    tags = {
        Name = "vitalii-terraform-test"
    }   
}

resource "aws_internet_gateway" "terraform-igw" {
    vpc_id = "${aws_vpc.vitalii-terraform-vpc.id}"  
}
resource "aws_subnet" "terraform-subnet" {
    vpc_id = "${aws_vpc.vitalii-terraform-vpc.id}"
    cidr_block = "10.100.1.0/24"
}
resource "aws_route_table" "terraform_route"{
    vpc_id = "${aws_vpc.vitalii-terraform-vpc.id}"
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform-igw.id}"
    }
}
resource "aws_route_table_association" "public-subnet"{
    subnet_id = "${aws_subnet.terraform-subnet.id}"
    route_table_id = "${aws_route_table.terraform_route.id}"
}
#--------Security group--------------------

resource "aws_security_group" "terraform_sg" {
    name = "WebServer SG"
    vpc_id = "${aws_vpc.vitalii-terraform-vpc.id}"
    description = "terraform security group"
    
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}