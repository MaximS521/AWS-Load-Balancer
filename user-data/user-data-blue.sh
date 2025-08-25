Replace the bucket name with your S3 bucket.
If you didn’t use the “root-index” files, health check to /red/index.html and /blue/index.html.

#!/bin/bash
yum update -y
yum install -y httpd awscli
systemctl start httpd
systemctl enable httpd

mkdir -p /var/www/html/blue
cd /var/www/html/blue

aws s3 cp s3://arr-bucket-maxproject2-1234/hw-blue.css .
aws s3 cp s3://arr-bucket-maxproject2-1234/hw-blue-py.css . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/python.png . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/apache.svg .
aws s3 cp s3://arr-bucket-maxproject2-1234/blue-index.html ./index.html

cd /var/www/html
aws s3 cp s3://arr-bucket-maxproject2-1234/hw-blue.css .
aws s3 cp s3://arr-bucket-maxproject2-1234/python.png . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/apache.svg .
aws s3 cp s3://arr-bucket-maxproject2-1234/blue-root-index.html ./index.html || true

systemctl restart httpd
