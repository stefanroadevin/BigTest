resource "tls_private_key" "endptkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private-key" {
  content  = tls_private_key.endptkey.private_key_pem
  filename = "endptkey.pem" 
}

resource "aws_key_pair" "deployer" {
  key_name   = "endptkey"
  public_key = tls_private_key.endptkey.public_key_openssh
}

resource "aws_instance" "public_instance" {
    ami = var.public_instance
    instance_type = "t2.micro"
    subnet_id = aws_subnet.my_vpc_public_subnet.id
    iam_instance_profile = aws_iam_instance_profile.Ec2Profile.name
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group_Public.id]
    tags = {
        Name="public_instance"
    }
}