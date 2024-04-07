#!/bin/bash

# This script is used to tear down the infrastructure set up by start.sh.
# It first destroys the Website infrastructure and then the Setup infrastructure, cleaning up the environment.

# Navigate to the Website directory and destroy the Terraform-managed infrastructure.
cd Website || exit
terraform destroy

# Restore the original terraform.tfvars file.
mv terraform.tfvars.bak terraform.tfvars

# Proceed to destroy the Setup infrastructure.
cd ../Setup || exit
terraform destroy

# Optional cleanup could be implemented here, for example:
# cd ..
# python SupportFunctions/cleanup.py
