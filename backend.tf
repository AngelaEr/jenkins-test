terraform {
	backend "s3" {
	        bucket = "bmc-practice-terraform-devops"
	        key    = "angela/terraform.tfstate"
	        region = "eu-central-1"
	}
}
