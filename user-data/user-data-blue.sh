#!/bin/bash
set -e
yum update -y
yum install -y httpd awscli
systemctl start httpd
systemctl enable httpd

# blue content
mkdir -p /var/www/html/blue
cd /var/www/html/blue

aws s3 cp s3://<YOUR-BUCKET-NAME>/hw-blue.css .
aws s3 cp s3://<YOUR-BUCKET-NAME>/python.png . || true
aws s3 cp s3://<YOUR-BUCKET-NAME>/apache.svg .
aws s3 cp s3://<YOUR-BUCKET-NAME>/blue-index.html ./index.html

# optional: set root index to blue version for quick checks
cd /var/www/html
aws s3 cp s3://<YOUR-BUCKET-NAME>/blue-root-index.html ./index.html || true

systemctl restart httpd
