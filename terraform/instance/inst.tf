module "network" {
  source = "../network"
  
}

resource "aws_instance" "my_webserver" {
    ami = "ami-085edf38cedbea498"
    instance_type = "t2.micro"
    subnet_id = "${module.network.t_subnet}"
    key_name = "vit-bastion"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${module.network.t_sg}"]
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
