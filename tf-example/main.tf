resource "aws_instance" "my_instance" {
  ami                    = "ami-06b09bfacae1453cb"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.my_subnet.id
  count                  = 2
  key_name               = "prin"
  instance_type          = "t2.micro"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.1.0/24"
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.1.0/27"

}

resource "aws_security_group" "my_security_group" {
  vpc_id      = aws_vpc.my_vpc.id
  description = "allowing ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
