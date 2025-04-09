output "ec2_public_ip" {
  description = "Public IP của EC2"
  value       = aws_instance.web.public_ip
}