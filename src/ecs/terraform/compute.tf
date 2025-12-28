data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2" {
  for_each = var.nic.ec2_cidrs

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2.instance_type

  iam_instance_profile = aws_iam_instance_profile.ecs_profile.name

  primary_network_interface {
    network_interface_id = aws_network_interface.ec2_nic[each.key].id
  }

  root_block_device {
    volume_type           = var.ec2.root_volume.type
    volume_size           = var.ec2.root_volume.size
    delete_on_termination = var.ec2.root_volume.delete_on_termination
    encrypted             = var.ec2.root_volume.encrypted
  }

  tags = var.tags
}