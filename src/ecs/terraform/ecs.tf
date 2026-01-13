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
# ECS Task Definition
# ================================

resource "aws_ecs_task_definition" "main" {
  family                   = var.ecs.task_definition.family
  network_mode             = var.ecs.task_definition.network_mode
  requires_compatibilities = var.ecs.task_definition.requires_compatibilities
  cpu                      = var.ecs.task_definition.cpu
  memory                   = var.ecs.task_definition.memory

  container_definitions = jsonencode([{
    name      = var.ecs.task_definition.container_name
    image     = var.ecs.task_definition.container_image
    cpu       = var.ecs.task_definition.container_cpu
    memory    = var.ecs.task_definition.container_memory
    essential = true

    portMappings = [{
      containerPort = var.ecs.task_definition.container_port
      hostPort      = var.ecs.task_definition.host_port
      protocol      = var.ecs.task_definition.protocol
    }]
  }])

  tags = var.tags
}

# ================================
# ECS Service
# ================================

resource "aws_ecs_service" "main" {
  name            = var.ecs.service.name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.ecs.service.desired_count
  launch_type     = var.ecs.service.launch_type

  tags = var.tags
}
