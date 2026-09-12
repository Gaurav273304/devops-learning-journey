# Day 14: IAM Policies, Roles & Security Groups Deep Dive

## What I did
Created a custom IAM policy with limited S3 permissions, created an IAM Role and attached the policy to it, attached the Role to an EC2 instance, and verified from inside the instance that AWS commands worked without any hardcoded credentials. Also went deep into how Security Groups work, including their stateful behavior.

## Concepts Learned

### IAM Policies (JSON)
A policy is a document defining what's allowed - on its own it does nothing until attached to a User or Role.
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:GetObject", "s3:PutObject"],
            "Resource": "arn:aws:s3:::*/*"
        }
    ]
}

### IAM Users vs IAM Roles
- User - tied to a specific person, with permanent credentials
- Role - temporary permissions that can be "assumed" by a service (like an EC2 instance) without any hardcoded password or access key

Why this matters: hardcoding AWS access keys inside an application risks leaking them and requires manual key rotation. A Role provides automatically-managed, temporary credentials instead - significantly reducing that risk.

### Attaching a Role to EC2
- Create the policy (define permissions)
- Create a Role, with Trusted entity type: AWS service (EC2 use case)
- Attach the policy to the Role
- Attach the Role to the EC2 instance (via Advanced Details at launch, or Actions > Security > Modify IAM role afterward)
- Verify from inside the instance

Verified this worked by running AWS CLI commands directly on the EC2 instance with zero credentials configured - the Role provided access automatically.

### Real error encountered and resolved
Running aws s3 ls from the EC2 instance initially failed with AccessDenied, even though the Role was correctly attached:
not authorized to perform: s3:ListAllMyBuckets

The Role attachment itself was working (confirmed by the assumed-role ARN in the error message) - the actual policy just didn't include the ListAllMyBuckets or ListBucket actions. Updated the policy to add both, and the commands worked immediately after.

Key lesson: attaching a Role doesn't guarantee every action will work - only what the underlying Policy explicitly allows.

### Security Groups (Deep Dive)
A virtual firewall controlling Inbound (what can reach the instance) and Outbound (what the instance can reach) traffic.

- Inbound is kept restrictive - only SSH (22) and HTTP (80) were allowed, to prevent unauthorized systems from initiating connections
- Outbound is left open by default (All traffic) - since the instance often needs to reach external services like S3, package repositories, or APIs

Stateful behavior: confirmed that Security Groups are stateful - if inbound traffic (like SSH or HTTP) is allowed, the response traffic is automatically permitted outbound, without needing a separate outbound rule.

## Files in this folder
- notes.md - working notes from both sessions

## Interview Question Prep

Q: What is the difference between an IAM User and an IAM Role?
A: A User has permanent credentials tied to a specific person. A Role provides temporary credentials that can be assumed by a service (like EC2) or another identity, with no hardcoded secrets involved.

Q: Why use an IAM Role instead of hardcoding AWS access keys in an application?
A: Hardcoded keys risk being leaked and require manual rotation. A Role gives automatically-managed, temporary credentials, which is significantly safer.

Q: What does it mean that Security Groups are stateful?
A: If inbound traffic is allowed (e.g. SSH), the response traffic is automatically allowed outbound - no separate outbound rule is required.

Q: If an IAM Role is attached to an EC2 instance but a command still fails with AccessDenied, what's the likely issue?
A: The Role being attached doesn't guarantee access - the underlying Policy needs to explicitly allow that specific action. The fix is updating the policy, not the Role attachment itself.
