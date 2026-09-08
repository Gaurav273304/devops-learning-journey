# Day 14: IAM Policies & Roles

## What I did
- Created custom IAM policy (S3ReadWriteOnly) with limited S3 permissions
- Created IAM Role, attached the policy
- Launched new EC2 instance with role attached at launch time
- Tested role from EC2: got AccessDenied for ListAllMyBuckets (policy didn't include it)
- Updated policy to add s3:ListAllMyBuckets and s3:ListBucket
- Successfully ran `aws s3 ls` from EC2 without any hardcoded credentials
