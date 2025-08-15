provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "tm_server" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.tmsecure.id ]

    user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF
    user_data_replace_on_change = true

    tags = {
      Name = "TDS-Build"
    }
  
}


resource "aws_security_group" "tmsecure" {
    name = "terraform-ex-instance"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}