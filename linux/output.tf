output "ips" {
  value = aws_instance.linux_vm[*].public_ip
}
