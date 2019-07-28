# AWS Credential
variable "access_key" {
    description = "AWS Access Key"
    default = ""
}
variable "secret_key" {
    description = "AWS Secret Key"
    default = ""
}

# AWS Region and Availablility Zone
variable "region" {
    default = "ap-southeast-2"
}

variable "availability_zone" {
    default = "ap-southeast-2a"
}

# VPC configuration
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
    default = "default"
}

variable "vpc_name" {
    default = "single-pafw-skillet-vpc"
}

# Untrust subnet configuration
variable "untrust_subnet_cidr_block" {
    default = "10.0.0.0/24"
}

# Trust subnet configuration
variable "trust_subnet_cidr_block" {
    default = "10.0.1.0/24"
}

# Management subnet configuration
variable "mgmt_subnet_cidr_block" {
    default = "10.0.2.0/24"
}

# PAVM configuration
variable "PANFWRegionMap_payg_bun2_ami_id" {
    // type = map
    default = {
          "us-east-1"      = "ami-050725600cf371a1c"
          "us-east-2"      = "ami-0340ae9cf0a892bb9"
          "us-west-1"      = "ami-02aa6330cd84b4020"
          "us-west-2"      = "ami-019b369b2201d17e1"
          "sa-east-1"      = "ami-05a40658314a5dc0f"
          "eu-west-1"      = "ami-08e82ba0784b4e5ac"
          "eu-west-2"      = "ami-0cea9a41443754f56"
          "eu-central-1"   = "ami-087597cf0637e3b39"
          "ca-central-1"   = "ami-0d179c6cdc2589b25"
          "ap-northeast-1" = "ami-0ca2e94970201db8d"
          "ap-northeast-2" = "ami-0a72f886dd8026c05"
          "ap-southeast-1" = "ami-050d7488f46b8e776"
          "ap-southeast-2" = "ami-0c3ced1b6948e91ac"
          "ap-south-1"     = "ami-001923acdc459e458"
    }
}

variable "PANFWRegionMap_byol_ami_id" {
    // type = map
    default = {
          "us-east-1"      = "ami-0012adac0a414863c"
          "us-east-2"      = "ami-04cb91d704368a8be"
          "us-west-1"      = "ami-0ca25d8ac63d17cc6"
          "us-west-2"      = "ami-094f3a5479b5096b8"
          "sa-east-1"      = "ami-0f4804ea341d4c397"
          "eu-west-1"      = "ami-05a20ed554111d2fb"
          "eu-west-2"      = "ami-04e0b601413d8a138"
          "eu-central-1"   = "ami-00f2ea8ebc29834a6"
          "ca-central-1"   = "ami-0c3940cfe30fd7853"
          "ap-northeast-1" = "ami-0a1fa1c292897d38e"
          "ap-northeast-2" = "ami-0e8e239b8b61bdc29"
          "ap-southeast-1" = "ami-0b6d59afd928af807"
          "ap-southeast-2" = "ami-0a31b0cc246e903e2"
          "ap-south-1"     = "ami-09b1600161c83f304"
    }
}

variable "UbuntuRegionMap" {
  type = "map"

    #Ubuntu Server 16.04 LTS (HVM)
    default = {
           "us-west-1"      = "ami-070b92a2ad613f657"
           "us-west-2"      = "ami-0f5eb23d395788b75"
           "us-east-1"      = "ami-076e36b130f0652ac"
           "us-east-2"      = "ami-0d535dd013b4e7e60"
           "ca-central-1"   = "ami-09ae60fb5234e5ed6"
           "eu-west-1"      = "ami-0cd4abf21ff96bfae"
           "eu-west-2"      = "ami-0f4c8d70e56e5eb4c"
           "eu-central-1"   = "ami-046780598f58f083a"
           "ap-east-1"      = "ami-24d8a055"
           "ap-northeast-1" = "ami-043cc3771fa9d5104"
           "ap-southeast-1" = "ami-08187eda459bc178b"
           "ap-southeast-2" = "ami-08b35c633895f95e1"
           "ap-south-1"     = "ami-0665aee2a4f3a4baa"
           "sa-east-1"      = "ami-06043b07a9bd283b0"
    }
}

variable "pavm_instance_type" {
    default = "m4.xlarge"
}

variable "pavm_key_name" {
    description = "Name of the SSH keypair to use in AWS."
    default = "dcaws-keypair"
}

variable "pavm_public_ip" {
    default = "true"
}

variable "pavm_untrust_private_ip" {
    default = "10.0.0.10"
}

variable "pavm_trust_private_ip" {
    default = "10.0.1.10"
}

variable "pavm_mgmt_private_ip" {
    default = "10.0.2.10"
}

variable "webserver_private_ip" {
    default = "10.0.1.50"
}