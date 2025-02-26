output "jenkins_url" {
  value = "http://${aws_instance.jenkins_ec2.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_instance.jenkins_ec2.public_ip}:9000"
}
