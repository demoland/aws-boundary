resource "aws_lb" "boundary_controller_lb" {
  name               = "boundary_controller_lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = local.public_subnets
}

resource "aws_lb_target_group" "boundary_controller_tg" {
  name        = "boundary_controller_target_group"
  port        = 9200
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/health"
    port                = "9200"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_instance.boundary_controller
  ]
}

resource "aws_lb_listener" "boundary_controller_listener" {
  load_balancer_arn = aws_lb.boundary_controller_lb.arn
  port              = 9200
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.boundary_controller_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "boundary_controller_tg_attachment" {
  count           = 3
  target_group_arn = aws_lb_target_group.boundary_controller_tg.arn
  target_id       = aws_instance.boundary_controller[count.index].id
  port            = 9200
}
