output "FW Username" {
  value = "admin"
}

output "FW Password" {
  value = "pal0alt0"
}

output "FW1-MGT-PRIVATEIP" {
  value = "${aws_network_interface.FW1-MGT.private_ip}"
}

output "FW1-MGT-PUBIP" {
  value = "https://${aws_eip.FW1-MGT.public_ip}"
}

output "FW1-UNTRUST-PUBIP" {
  value = "${aws_eip.FW1-PUB.public_ip}"
}

output "FW1-UNTRUST-PRIVATEIP" {
  value = "${aws_network_interface.FW1-UNTRUST.private_ip}"
}

output "FW1-TRUST-PRIVATEIP" {
  value = "${aws_network_interface.FW1-TRUST.private_ip}"
}

output "WEBSERVER-PRIVATEIP" {
  value = "${aws_network_interface.web1-int.private_ip}"
}

output "WEBSERVER-PUBLIC-ACCESS" {
  value = "ping -o ${aws_eip.FW1-PUB.public_ip}; ssh -i ${var.pavm_key_name}.pem ubuntu@${aws_eip.FW1-PUB.public_ip}"
}