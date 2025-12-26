data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2.instance_type

  # subnet_id = map()

  iam_instance_profile = aws_iam_instance_profile.ecs_profile.name

  tags = var.tags
}

resource "aws_network_interface_attachment" "nic_attachment" {
  for_each = var.nic.ec2_cidrs

  instance_id          = aws_instance.ec2.id
  network_interface_id = aws_network_interface.ec2_nic[each.key].id
  device_index         = index(keys(var.nic.ec2_cidrs), each.key)
}