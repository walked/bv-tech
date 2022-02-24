resource "aws_lb" "bvco-alb" {
  name               = "alb"
  subnets            = "${module.vpc.public_subnets}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.bvco-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bv-tg.arn
  }
}

resource "aws_lb_target_group" "bv-tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${module.vpc.vpc_id}"
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }
}