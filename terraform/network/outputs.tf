output "t_vpc" {
  value = "${aws_vpc.vitalii-terraform-vpc.id}"
}
output "t_subnet" {
  value = "${aws_subnet.terraform-subnet.id}"
}
output "t_sg" {
  value = "${aws_security_group.terraform_sg.id}"
}

