#!/bin/bash

# Run the main script.
cd Website || exit

terraform destroy

# Destroy the S3 bucket. Must be done after Website is destroyed.
cd ../Setup || exit

terraform destroy

# Clean up environment.
# cd ..
# python supportFunctions/remove_providers.py
