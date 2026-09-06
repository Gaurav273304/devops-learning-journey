# Day 13: AWS Fundamentals - IAM, EC2, S3 (with Live Deployment)

## What I did
Set up an AWS account, learned IAM basics, created an IAM user, hit a real 
account verification hold on EC2 (resolved it by submitting documents), 
created an S3 bucket, and - after the hold cleared - successfully launched 
an EC2 instance and deployed a live, internet-accessible nginx web server on it.

## Concepts Learned

### Why AWS
Instead of building and maintaining a physical server room, AWS lets 
companies rent servers, storage, databases, and networking over the 
internet - paying only for what they use, and scaling up or down as needed.

### IAM (Identity and Access Management)
Controls who can do what within an AWS account - the foundation of AWS security.
- **Root user** - created at sign-up; has full, unrestricted access. 
  Should never be used for daily tasks, since a compromised root account 
  means the entire account is at risk.
- **IAM user** - created for day-to-day work, with specific/limited 
  permissions attached via policies.
- **Important:** IAM is a **global** service - it has no region, unlike 
  EC2 or S3 which are region-specific.

### EC2 (Elastic Compute Cloud)
A virtual server in the cloud - the real-world version of the "Node" 
concept from Kubernetes (Day 10), except this is an actual internet-facing 
machine, not a local simulation like minikube.
- `t3.micro` - free-tier eligible instance type, avoids being charged
- A `.pem` key pair is generated at launch time and used to SSH into the 
  instance - the same SSH concept practiced back on Day 4, now against a 
  real cloud server instead of localhost

### S3 (Simple Storage Service)
Cloud file storage organized into "buckets" (each bucket name must be 
globally unique across all of AWS). Uploaded a file and confirmed that 
its direct URL returns "Access Denied" - S3 buckets are private by 
default as a security measure.

## Live Deployment Walkthrough

**1. Connected to the EC2 instance via SSH:**
```bash
chmod 400 first-web-server.pem
ssh -i first-web-server.pem ubuntu@<public-dns>
```

**2. Installed and started nginx on the server:**
```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl status nginx
```

**3. Fixed access by updating the Security Group** (AWS's firewall) - by 
default only SSH (port 22) is open on a new instance. Had to add an 
inbound rule allowing HTTP (port 80) from `0.0.0.0/0` before the site 
was reachable from a browser.

**4. Verified the site was live** by visiting `http://<public-ip>` in a 
browser and seeing the nginx welcome page - my first real, internet-facing 
cloud deployment.

## Where I got stuck

**Account verification hold:** EC2 launch initially failed with "account 
blocked and not recognized as a valid account." AWS had flagged the new 
account for verification and required documents to be submitted. Uploaded 
them and switched to working on S3 in the meantime rather than waiting 
idle - the hold cleared roughly 20 hours later.

**Security Group confusion:** After nginx was confirmed running 
(`curl localhost` worked directly on the server), the site still wasn't 
reachable from a browser. Realized the default Security Group only allows 
SSH - had to explicitly add an inbound rule for HTTP (port 80) before 
external access worked.

**IAM's global nature:** Initially kept trying to select a region on the 
IAM page before realizing this isn't possible - IAM applies account-wide 
regardless of region, unlike EC2 or S3 where region selection matters.

## Files in this folder
- `notes.md` - working notes from the session

## Interview Question Prep

**Q: Why shouldn't you use the root account for daily tasks?**
A: The root account has unrestricted access to everything in the AWS 
account. If its credentials were ever compromised, the entire account 
would be at risk. IAM users with limited, specific permissions are used 
instead for daily work.

**Q: Why are S3 buckets private by default?**
A: To prevent sensitive data from being accidentally exposed to the 
public internet - AWS defaults to the more restrictive/secure option.

**Q: What's the significance of using a t3/t2.micro instance?**
A: It's free-tier eligible, meaning it can run a set number of hours per 
month without being charged - useful for learning and testing without 
incurring costs.

**Q: Is IAM tied to a specific AWS region?**
A: No - IAM is a global service. It applies across the entire AWS account 
regardless of region, unlike EC2 or S3 which are region-specific.

**Q: If your EC2 instance is running but you can't reach it from a 
browser, what's the first thing you'd check?**
A: The Security Group's inbound rules. By default, only SSH (port 22) is 
open - HTTP (port 80) or HTTPS (port 443) must be explicitly allowed for 
the instance to be reachable from a browser, even if the web server 
itself is running correctly.
