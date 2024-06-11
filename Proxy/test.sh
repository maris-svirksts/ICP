#!/bin/bash

# Retrieve the CloudFront domain name from CloudFormation stack outputs
CLOUDFRONT_DOMAIN=proxy-lb-900798496.eu-north-1.elb.amazonaws.com

# Set proxy environment variables
export http_proxy=http://$CLOUDFRONT_DOMAIN:80
export https_proxy=https://$CLOUDFRONT_DOMAIN:443

# Test the proxy setup
echo "Testing HTTP proxy..."
curl -I http://www.google.com

echo "Testing HTTPS proxy..."
curl -I https://www.google.com
