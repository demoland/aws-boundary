output "private_ips" {
    value = aws_instance.boundary_controller.*.private_ip
    description = "The public DNS of the Boundary Controllers" 
}

output "boundary_controller_lb" {
    value = aws_lb.boundary_controller_lb.dns_name
    description = "The public DNS of the Boundary Controllers" 
}