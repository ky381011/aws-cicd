data "aws_ami" "selected" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ec2.ami.name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ec2.ami.virtualization_type]
  }

  owners = [var.ec2.ami.owner_id]
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.ssh_key.name
  public_key = var.ssh_key.public_key
}

locals {
  nic_keys            = keys(var.ec2.nics)
  primary_nic_key     = local.nic_keys[0]
  additional_nic_keys = slice(local.nic_keys, 1, length(local.nic_keys))
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.selected.id
  instance_type = var.ec2.instance_type
  key_name      = aws_key_pair.ec2_key.key_name

  iam_instance_profile = aws_iam_instance_profile.ecs_profile.name

  primary_network_interface {
    network_interface_id = aws_network_interface.ec2_nic[local.primary_nic_key].id
  }

  root_block_device {
    volume_type           = var.ec2.root_volume.type
    volume_size           = var.ec2.root_volume.size
    delete_on_termination = var.ec2.root_volume.delete_on_termination
    encrypted             = var.ec2.root_volume.encrypted
  }

  // user_data = ...

  tags = var.tags
}

resource "aws_network_interface_attachment" "additional_nics" {
  for_each = toset(local.additional_nic_keys)

  instance_id          = aws_instance.ec2.id
  network_interface_id = aws_network_interface.ec2_nic[each.key].id
  device_index         = index(local.additional_nic_keys, each.key) + 1
}