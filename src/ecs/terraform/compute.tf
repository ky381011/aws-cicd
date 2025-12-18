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
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # subnet_id = map()

  iam_instance_profile = aws_iam_instance_profile.ecs_profile.name

  tags = var.tags
}

resource "aws_network_interface_attachment" "nic_attachment" {
  for_each = var.ec2_nic_cidrs

  instance_id          = aws_instance.ec2.id
  network_interface_id = aws_network_interface.ec2_nic[each.key].id
  device_index         = index(keys(var.ec2_nic_cidrs), each.key)
}