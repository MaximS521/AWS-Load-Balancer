Replace arr-bucket-maxproject2-1234 with your actual bucket name.

#!/bin/bash
set -e
yum update -y
yum install -y httpd awscli
systemctl start httpd
systemctl enable httpd

# red content
mkdir -p /var/www/html/red
cd /var/www/html/red

aws s3 cp s3://arr-bucket-maxproject2-1234/hw-red.css .
aws s3 cp s3://arr-bucket-maxproject2-1234/python.png . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/apache.svg .
aws s3 cp s3://arr-bucket-maxproject2-1234/red-index.html ./index.html

# optional: set root index to red version for quick checks
cd /var/www/html
aws s3 cp s3://arr-bucket-maxproject2-1234/red-root-index.html ./index.html || true

systemctl restart httpd
