resource "aws_key_pair" "cicd-keypair" {
  key_name   = "cicd-keypair"
  public_key = file("cicd-keypair.pub")
}

resource "aws_instance" "dove-inst" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id 
  key_name               = aws_key_pair.cicd-keypair.key_name
  vpc_security_group_ids = ["sg-085e2c968b0c3ad84"]

  # Associate a public IP to this instance
  associate_public_ip_address = true

  tags = {
    Name    = "app"
    Project = "ashleyweb"
  }
}

resource "null_resource" "provision" {
  depends_on = [aws_instance.dove-inst]

  provisioner "file" {
    source      = "web.sh"
    destination = "/home/ubuntu/web.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("cicd-keypair")
      host        = aws_instance.dove-inst.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/\r//' /home/ubuntu/web.sh",   # Remove any CR characters
      "sudo chmod +x /home/ubuntu/web.sh",           # Make sure it's executable
      "sudo /home/ubuntu/web.sh"                     # Run the script
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("cicd-keypair")
      host        = aws_instance.dove-inst.public_ip
    }
  }
}
