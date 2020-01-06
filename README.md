# Terraform scripts to deploy high availability VM architectures in Azure

Scripts supporting this [blog post](https://adrianbumbas.com/how-to-create-iaas-high-availability-architectures-in-azure-with-terraform/).

Fill in the needed values in the file `terraform.tfvars`
The file `as.tf` contains the setup for three VMs deployed in two availability sets.
The file `az.tf` contains the setup for three VMs deployed in three avaialabilty sets inside the same region.
