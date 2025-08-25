#!/bin/bash
set -e
yum update -y
yum install -y httpd awscli
systemctl start httpd
systemctl enable httpd

# red content
mkdir -p /var/www/html/red
cd /var/www/html/red

aws s3 cp s3://<YOUR-BUCKET-NAME>/hw-red.css .
aws s3 cp s3://<YOUR-BUCKET-NAME>/python.png . || true
aws s3 cp s3://<YOUR-BUCKET-NAME>/apache.svg .
aws s3 cp s3://<YOUR-BUCKET-NAME>/red-index.html ./index.html

# optional: set root index to red version for quick checks
cd /var/www/html
aws s3 cp s3://<YOUR-BUCKET-NAME>/red-root-index.html ./index.html || true

systemctl restart httpd
