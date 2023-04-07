output "boundary_endpoint" {
    value = aws_instance.boundary.public_dns[count.index]
    description = "The public DNS of the Boundary server" 
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