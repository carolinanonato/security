output "ips" {
  value = aws_instance.windows_vm[*].public_ip
}