resource "aws_ecs_cluster" "bv-poc-ecs" {
  name = "bv-ecs-cluster"
}


## Future Improvement: Would segment the task definition into a template file and render using inputs instead of in-line.
resource "aws_ecs_task_definition" "bv-task" {
  family                   = "bv-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TD
[
  {
    "name": "poc-node",
    "image": "walked/poc-node",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort"      : 3000
        }
    ]
  }
]
TD

}



## ECS Service; associated with fargate
## Tied to 2 public subnets (can be extended to 3+)
## Desired count set to 1 due to my own billing ;)

resource "aws_ecs_service" "bv-poc" {
  name            = "bv-poc"
  cluster         = aws_ecs_cluster.bv-poc-ecs.id
  task_definition = aws_ecs_task_definition.bv-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = "${module.vpc.public_subnets}"
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.bv-tg.arn
    container_name   = "poc-node"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.https_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]

}