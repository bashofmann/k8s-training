output "node_ips" {
  value = aws_instance.k3s.*.public_ip
}