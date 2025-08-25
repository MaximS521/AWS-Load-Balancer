# AWS-Load-Balancer
# AWS ALB Advanced Request Routing (Red/Blue)

Hands-on project deploying a **load-balanced, highly available** web app on AWS with **Application Load Balancer (ALB)** and **Route 53**. The ALB routes requests to “Red” and “Blue” versions using **path-based** and **host-based** rules.

> Region: `us-east-1`  
> Project alias: `maxproject2`

## 🧩 Architecture

![architecture](assets/architecture-diagram.png)

**Services**: S3, EC2 (Amazon Linux), Security Groups, Target Groups, Application Load Balancer, Route 53.

**Routing modes**:
- Path-based: `/red*` → Red TG, `/blue*` → Blue TG
- Host-based: `red.smuddin.com` → Red TG, `blue.smuddin.com` → Blue TG
- Default rule: return 404 (optional)

---

## 📂 Contents

- `user-data/` – EC2 user data scripts that install Apache and pull site files from S3
- `s3/` – sample site content (red & blue)
- `iam/bucket-permissions.json` – bucket policy allowing `GetObject`
- `assets/` – screenshots and diagram for README/Medium
- `docs/` – optional step-by-step notes

---

## 🚀 Quick Start (Console workflow)

1. **S3**
   - Create a bucket, e.g. `arr-bucket-maxproject2-1234`
   - Upload files from `/s3` (red & blue assets)
   - Apply a bucket policy like `iam/bucket-permissions.json` (replace `YOUR-BUCKET-ARN`)

2. **EC2**
   - Launch 2 Amazon Linux instances (t3.micro OK)
   - Use `user-data/user-data-red.sh` for Red, `user-data/user-data-blue.sh` for Blue
   - Security Group: allow inbound **HTTP (80)** from `0.0.0.0/0`

3. **Target Groups**
   - Create TG **Red** (port 80), register Red instance
   - Create TG **Blue** (port 80), register Blue instance
   - Health check path examples:
     - Red: `/red/index.html`
     - Blue: `/blue/index.html`

4. **ALB**
   - Internet-facing Application Load Balancer across 2 subnets
   - Listener **HTTP:80**
   - **Add rules**:
     - Path-based phase:
       - `/red*` → forward to **Red**
       - `/blue*` → forward to **Blue**
     - Host-based phase:
       - Host header `red.smuddin.com` → **Red**
       - Host header `blue.smuddin.com` → **Blue**
     - Default rule: return **404** (optional)

5. **Route 53**
   - Public hosted zone: `smuddin.com`
   - Records:
     - `red.smuddin.com` → **A Alias** → ALB
     - `blue.smuddin.com` → **A Alias** → ALB

6. **Test**
   - `http://red.smuddin.com`
   - `http://blue.smuddin.com`

> If DNS hasn’t propagated: flush local DNS or temporarily add hosts entries pointing subdomains to ALB IPs.

---

## 🔧 User data scripts

### `user-data/user-data-red.sh`
```bash
#!/bin/bash
yum update -y
yum install -y httpd awscli
systemctl start httpd
systemctl enable httpd

# directories
mkdir -p /var/www/html/red
cd /var/www/html/red

# copy from S3 (replace with your bucket)
aws s3 cp s3://arr-bucket-maxproject2-1234/hw-red.css .
aws s3 cp s3://arr-bucket-maxproject2-1234/hw-red-py.css . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/python.png . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/apache.svg .
aws s3 cp s3://arr-bucket-maxproject2-1234/red-index.html ./index.html

# replace default root page with red root if desired
cd /var/www/html
aws s3 cp s3://arr-bucket-maxproject2-1234/hw-red.css .
aws s3 cp s3://arr-bucket-maxproject2-1234/python.png . || true
aws s3 cp s3://arr-bucket-maxproject2-1234/apache.svg .
aws s3 cp s3://arr-bucket-maxproject2-1234/red-root-index.html ./index.html || true

systemctl restart httpd
