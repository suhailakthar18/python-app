

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("${path.module}/../../my-key.pub")

}


resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  user_data = <<-EOF
              #!/bin/bash

              # Update packages
              sudo apt-get update -y

              # Install dependencies for Docker
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

              # Add Docker’s official GPG key
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

              # Set up Docker stable repository
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

              # Install Docker
              sudo apt-get update -y
              sudo apt-get install -y docker-ce

              # Start Docker service
              sudo systemctl start docker
              sudo systemctl enable docker

              # Install Docker Compose
              sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

              # Make Docker Compose executable
              sudo chmod +x /usr/local/bin/docker-compose

              # Install Jenkins
              wget -q -O - https://pkg.jenkins.io/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo "deb http://pkg.jenkins.io/debian/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/jenkins.list'
              sudo apt-get update -y
              sudo apt-get install -y jenkins

              # Add Jenkins to Docker and Ubuntu groups
              sudo usermod -aG docker jenkins
              sudo usermod -aG docker $USER
              sudo usermod -aG ubuntu jenkins

              # Restart Jenkins service to apply changes
              sudo systemctl restart jenkins

              # Verify installation of Docker, Docker Compose, and Jenkins
              docker --version
              docker-compose --version
              java -version
              jenkins --version
              EOF

  tags = {
    Name = "UbuntuEC2"
  }
}
