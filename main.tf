/*Chaise - I'm using the comments as a way of putting what I'm doing into my own words
more than to explain what's happening in each section. -Jake*/

/*The Terraform block provides instructions for Terraform itself vice the 
infrastructure you're using it to build. In this case, we're specifying
a backend, S3, and a required provider, AWS. */

terraform {
    /*Backends configure where you store the TF state. Default Backend is usually local, but we're using s3.*/
    backend "s3" {
    bucket = "terraform-practice-s3"
    key    = "main.tfstate"
    region = "us-west-2"
    }
    /*Requires the AWS provider from the TF Registry to be used in the code, and specifies
    a version number*/
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.6.0"
        }
    }
}

#Declares the provider we'll be using. In this case AWS
provider "aws" {
    region = "us-west-2"
}

#Creates a VPC with an IP range, turns on DNS support, and adds an AWS tag
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "Terraform VPC"
    }
}

#Creates an internet gateway so the VPC can be accesed from the internet
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}

#Creates a public subnet within the VPC with a defined Availability Zone
resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"
}

#Creates a routing table to direct all internet traffic to the internet gateway
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

#Associates the routing table with the public subnet
resource "aws_route_table_association" "route_table_association" {
    subnet_id = aws_subnet.pub_subnet.id
    route_table_id = aws_route_table.public.id
}