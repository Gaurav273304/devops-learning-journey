# Linux DevOps Roadmap

This repo is my daily DevOps learning log — starting from Linux fundamentals and working my way up through Git, Bash scripting, Docker, and beyond. Each folder represents one day of practice: the commands I tried, the scripts I wrote, the mistakes I made, and what I actually learned.

This isn't a polished tutorial — it's my real, day-by-day practice log.

## Progress Log

| Day | Topic | What I actually did |
|-----|-------|----------------------|
| [01-02](./day01-02-linux-basics) | Linux Basics | Covered Linux navigation, file operations, permissions (chmod/chown), and wrote my first bash script |
| [03](./day03-process-management) | Process & Service Management | Built a health check script, got comfortable with `ps`/`top` |
| [04](./day04-networking) | Networking | DNS, ports, SSH — used `netstat` for the first time in a real scenario |
| [05](./day05-bash-scripting) | Bash Scripting | Wrote a log monitor script — my first real automation using `grep`/`awk` |
| [06](./day06-git-basics) | Git Deep Dive | Practiced branching, resolved my first real merge conflict, set up .gitignore |
| [07](./day07-week1-project) | Week 1 Revision + Project | Took a revision test, then built a Server Health Monitor script combining the whole week's concepts |
| [08](./day08-docker) | Docker Fundamentals | Built and ran my first custom Docker image — an nginx container serving my own webpage |
| [09](./day09-docker-advanced) | Docker Volumes, Networking & Compose | Built a multi-container setup (nginx + MySQL) using volumes, custom networks, and Docker Compose |
| [10](./day10-kubernetes-basics) | Kubernetes Fundamentals | Deployed my first app on minikube and tested self-healing by deleting a Pod |
| [11](./day11-kubernetes-services) | Kubernetes Services, Scaling & ConfigMaps | Learned why Services exist, scaled a deployment, and injected config via ConfigMap |
| [12](./day12-kubernetes-project) | Kubernetes Persistent Volumes + Week 2 Project | Debugged a storageClassName mismatch and combined Deployment, Service, ConfigMap, and PVC into one project |
| [13](./day13-aws-basics) | AWS Fundamentals (IAM, EC2, S3) | Set up IAM, hit an EC2 account verification hold, and practiced S3 bucket basics |
| [14](./day14-iam-policies-roles) | IAM Policies, Roles & Security Groups | Attached an IAM Role to EC2, debugged a real AccessDenied error, and learned Security Group statefulness |

## Setup

- OS: Ubuntu (Linux)
- I push my progress to GitHub daily after finishing each day's practice

## Goal

To build a solid foundation in Linux, then move step by step into Docker, CI/CD, and cloud tools — with daily, consistent practice.
