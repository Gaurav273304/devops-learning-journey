# Week 3, Day 1: AWS Fundamentals

## What I did
- Created AWS account, set up MFA
- Created IAM user with console access
- Attempted EC2 instance launch (hit account verification hold - submitted required documents)
- Created S3 bucket, uploaded a file, verified default private access

## Key Learnings
- IAM is a global service (no region)
- EC2/S3 are region-specific
- t2.micro is free-tier eligible
- S3 buckets are private by default (security)

## Update - EC2 Successfully Launched
- Verification hold cleared after ~20 hours
- Successfully launched EC2 instance (t3.micro)
- Connected via SSH using .pem key
- Installed nginx on the server
- Fixed Security Group to allow HTTP (port 80) traffic
- Verified website live and accessible via public IP
