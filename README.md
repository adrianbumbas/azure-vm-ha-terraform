# Terraform scripts to deploy high availability VM architectures

Scripts supporting this [blog post] ().

Fill in the needed values in the file `terraform.tfvars`
The file `as.tf` contains the setup for three VMs deployed in two availability sets.
The file `az.tf` contains the setup for three VMs deployed in three avaialabilty sets inside the same region.