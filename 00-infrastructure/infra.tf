resource "aws_key_pair" "key_pair" {
  key_name_prefix = "k8s-training-key-"
  public_key      = file("${var.ssh_key_file_name}.pub")
}

resource "aws_security_group" "sg_allowall" {
  name        = "k8s-training-key-sg"
  description = "Rancher quickstart - allow all traffic"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k3s" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name        = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.sg_allowall.name]

  root_block_device {
    volume_size = 80
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_key_file_name)
    }
  }

  tags = {
    Name        = "k8s-training-key-${count.index}"
    Owner       = "bhofmann"
    DoNotDelete = "true"
  }
}
