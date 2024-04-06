#!/bin/bash

# Run the main script.
cd Website || exit

terraform destroy # -auto-approve

mv -f terraform.tfvars.bak terraform.tfvars

# Destroy the S3 bucket. Must be done after Website is destroyed.
cd ../Setup || exit

terraform destroy # -auto-approve

# Clean up environment.
# cd ..
# python supportFunctions/remove_providers.py
