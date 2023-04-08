output "private_ips" {
    value = aws_instance.boundary_controller.*.private_ip
    description = "The public DNS of the Boundary Controllers" 
}

/*
output "boundary_auth_method_id" {
    value = aws_instance.boundary.public_dns
    description = "The public DNS of the Boundary server" 
}

output "boundary_auth_method_type" {
    value = aws_instance.boundary.method_type
    description = "The Boundary Auth Method Type"
}
*/