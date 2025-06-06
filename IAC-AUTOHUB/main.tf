terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

module "network" {
  source = "./network"
}


module "instances" {
  source               = "./instances"
  vpc_id               = module.network.vpc_id
  subnet_publica_id    = module.network.subnet_publica_id
  subnet_private_id    = module.network.subnet_private_id
  security_public_id   = module.network.security_public_id
  security_private_id  = module.network.security_private_id
}

resource "aws_eip" "ip_instancia-publica" {
  vpc = true

  tags = {
    Name = "AUTOHUB-NOVO-IP-PUBLICA"
  }



}

resource "aws_eip_association" "assoc_ip_publica" {
  instance_id   = module.instances.public_instance_id
  allocation_id = aws_eip.ip_instancia-publica.id
}
# scp -i keys/autohub_chave.pem keys/autohub-banco.pem ubuntu@54.147.227.169:/home/ubuntu/.ssh/autohub-banco.pem	
# ssh -i "keys/autohub_chave.pem" ubuntu@ec2-54-147-227-169.compute-1.amazonaws.com
# ssh -i "keys/autohub_chave.pem" ubuntu@ec2-54-234-76-237.compute-1.amazonaws.com
# scp -i keys/autohub_chave.pem keys/autohub_chave.pem ubuntu@54.147.227.169:/home/ubuntu/.ssh/autohub_chave.pem	
# ssh -i "keys/autohub_chave.pem" ubuntu@ec2-44-206-70-231.compute-1.amazonaws.com
# ssh -i ".ssh/autohub_chave.pem" ubuntu@10.0.1.38
# ssh -i ".ssh/autohub_chave.pem" ubuntu@ec2-54-174-6-172.compute-1.amazonaws.com
# http://3.91.241.173/api/swagger-ui/index.html
# sudo docker run -p 8080:8080 -d matteusnogueira/autohub-backend:v1.1
# sudo docker logs $(docker ps -q --filter matteusnogueira/autohub-backend)

#terraform import aws_eip.ip_instancia-publica eipalloc-0bf96970325aaa9e8
#terraform state rm aws_eip.ip_instancia-publica

#terraform import aws_eip.ip_instancia-publica eipalloc-0583115e631277deb

# scp -i .ssh/autohub-banco.pem backupBanco/backupBanco.bak ec2-54-147-227-169.compute-1.amazonaws.com:/home/ubuntu/backupBanco/backupBanco.bak	

#3.92.191.228
#ssh -i "autohub_chave.pem" ubuntu@10.0.1.161


# matteus@matteus-Nitro-AN515-57:~/Documents/Facul/autohub/IAC-AUTOHUB$ cp terraform.tfstate terraform.tfstate.bkp
# matteus@matteus-Nitro-AN515-57:~/Documents/Facul/autohub/IAC-AUTOHUB$ terraform state rm aws_eip.ip_instancia-publica

# 