# ================================
# ECS Cluster
# ================================

resource "aws_ecs_cluster" "main" {
  name = var.ecs.cluster.name

  setting {
    name  = "containerInsights"
    value = var.ecs.cluster.container_insights
  }

  tags = var.tags
}

# ================================
# ECS Task Definitions
# ================================

resource "aws_ecs_task_definition" "tasks" {
  for_each = var.ecs.task_definitions

  family                   = each.value.family
  network_mode             = each.value.network_mode
  requires_compatibilities = each.value.requires_compatibilities
  cpu                      = each.value.cpu
  memory                   = each.value.memory

  container_definitions = jsonencode([{
    name      = each.value.container_name
    image     = each.value.container_image
    cpu       = each.value.container_cpu
    memory    = each.value.container_memory
    essential = true

    portMappings = [{
      containerPort = each.value.container_port
      hostPort      = each.value.host_port
      protocol      = each.value.protocol
    }]
  }])

  tags = var.tags
}

# ================================
# ECS Services
# ================================

resource "aws_ecs_service" "services" {
  for_each = var.ecs.services

  name            = each.key
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.tasks[each.value.task_key].arn
  desired_count   = each.value.desired_count
  launch_type     = each.value.launch_type

  tags = var.tags
}
