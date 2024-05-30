#!/bin/bash
# Validate service script
echo "Running ValidateService script..."
curl -f http://localhost/ || exit 1