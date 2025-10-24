﻿ðŸ—ï¸ AWS Multi-Tier VPC Architecture
[REMOVED]-Ready Network Design with Public/Private Subnet Segmentation
Show Image
Show Image
Show Image
Show Image
</div>

ðŸŽ¯ PROJECT OVERVIEW
This project demonstrates a [REMOVED]-grade VPC architecture that follows AWS networking best practices. It's not just "create a VPC and some subnets"â€”it's a fully segmented, secure, and scalable network foundation that enterprise applications are built on.
Why This Matters
VPC design is the foundation of everything in AWS. Get this wrong and you'll face:

âŒ Security vulnerabilities (exposed private resources)
âŒ Routing nightmares (misconfigured route tables)
âŒ No scalability (poor CIDR planning)
âŒ Compliance failures (no network segmentation)

This project proves I understand network architecture at the infrastructure level, not just "click buttons in the console."

ðŸ—ï¸ ARCHITECTURE
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                      AWS VPC (10.0.0.0/16)                       â”‚
â”‚                                                                   â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚              Availability Zone A (us-east-1a)            â”‚   â”‚
â”‚  â”‚                                                           â”‚   â”‚
â”‚  â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”‚   â”‚
â”‚  â”‚  â”‚  Public Subnet A     â”‚  â”‚  Private Subnet A    â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  10.0.1.0/24         â”‚  â”‚  10.0.11.0/24        â”‚    â”‚   â”‚
â”‚  â”‚  â”‚                      â”‚  â”‚                      â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  â€¢ NAT Gateway       â”‚  â”‚  â€¢ App Servers       â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  â€¢ Load Balancer     â”‚  â”‚  â€¢ Lambda Functions  â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  â€¢ Bastion Host      â”‚  â”‚  â€¢ Private Resources â”‚    â”‚   â”‚
â”‚  â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚   â”‚
â”‚  â”‚             â”‚                           â”‚                â”‚   â”‚
â”‚  â”‚        Internet                    Route to NAT         â”‚   â”‚
â”‚  â”‚        Gateway                                          â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”‚                                                                   â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚              Availability Zone B (us-east-1b)            â”‚   â”‚
â”‚  â”‚                                                           â”‚   â”‚
â”‚  â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”‚   â”‚
â”‚  â”‚  â”‚  Public Subnet B     â”‚  â”‚  Private Subnet B    â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  10.0.2.0/24         â”‚  â”‚  10.0.12.0/24        â”‚    â”‚   â”‚
â”‚  â”‚  â”‚                      â”‚  â”‚                      â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  â€¢ NAT Gateway       â”‚  â”‚  â€¢ App Servers       â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  â€¢ Load Balancer     â”‚  â”‚  â€¢ Database Layer    â”‚    â”‚   â”‚
â”‚  â”‚  â”‚  â€¢ Failover          â”‚  â”‚  â€¢ High Availability â”‚    â”‚   â”‚
â”‚  â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚   â”‚
â”‚  â”‚             â”‚                           â”‚                â”‚   â”‚
â”‚  â”‚        Internet                    Route to NAT         â”‚   â”‚
â”‚  â”‚        Gateway                                          â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”‚                                                                   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

            â–²                                    â–²
            â”‚                                    â”‚
      Internet Traffic              Internal Traffic (Isolated)

ðŸ”¥ KEY FEATURES
ðŸ” Security by Design

Public/Private subnet separation - Internet-facing vs internal resources
Network ACLs - Subnet-level firewall rules
Security Groups - Instance-level stateful firewalls
Private subnets have no direct internet - All outbound via NAT Gateway
Bastion host architecture - Secure SSH access to private resources

âš¡ High Availability

Multi-AZ deployment - Resources spread across 2+ availability zones
Redundant NAT Gateways - One per AZ for fault tolerance
Independent route tables - Per-subnet routing for flexibility
Elastic IP addresses - Static IPs for NAT Gateways

ðŸ› ï¸ Scalability

Smart CIDR planning - Room to grow (10.0.0.0/16 = 65,536 IPs)
Modular subnet design - Easy to add more tiers (database, cache)
VPC peering ready - Can connect to other VPCs
Transit Gateway compatible - Enterprise-scale networking

ðŸ’° Cost Awareness

NAT Gateway pricing - Per hour + data transfer ($0.045/hour + $0.045/GB)
Elastic IP costs - Only when unattached to instances
Data transfer optimization - Keep traffic within VPC when possible


ðŸš€ WHAT I LEARNED
Building this taught me:

CIDR block planning is critical - Can't change VPC CIDR easily after creation
Route tables are the brain - Every subnet needs correct routing
NAT Gateways cost money - One per AZ adds up fast ($65+/month)
Security Groups vs NACLs - Stateful vs stateless firewalls
Internet Gateway is shared - One IGW per VPC, attached to public subnets
Subnet sizing matters - AWS reserves 5 IPs per subnet (.0, .1, .2, .3, .255)


ðŸ“‹ TECHNICAL IMPLEMENTATION
Tech Stack

AWS VPC - Virtual network isolation
AWS Subnets - Public and private network segments
NAT Gateway - Outbound internet for private subnets
Internet Gateway - Inbound/outbound for public subnets
Route Tables - Traffic routing rules
Security Groups - Instance-level firewall
Network ACLs - Subnet-level firewall
Terraform - Infrastructure as Code

Network Design Breakdown
VPC Configuration
hclCIDR Block: 10.0.0.0/16 (65,536 IPs)
DNS Resolution: Enabled
DNS Hostnames: Enabled
Tenancy: Default (shared hardware)
Public Subnets (2 AZs)
hclSubnet A: 10.0.1.0/24 (256 IPs) - us-east-1a
Subnet B: 10.0.2.0/24 (256 IPs) - us-east-1b

Route Table:
- 0.0.0.0/0 â†’ Internet Gateway
- 10.0.0.0/16 â†’ Local

Resources:
- Load Balancers (ALB/NLB)
- NAT Gateways
- Bastion Hosts
Private Subnets (2 AZs)
hclSubnet A: 10.0.11.0/24 (256 IPs) - us-east-1a
Subnet B: 10.0.12.0/24 (256 IPs) - us-east-1b

Route Table:
- 0.0.0.0/0 â†’ NAT Gateway (per AZ)
- 10.0.0.0/16 â†’ Local

Resources:
- EC2 Application Servers
- RDS Databases (private subnet group)
- ElastiCache Clusters
- Lambda Functions (VPC-attached)
Security Groups
hclPublic ALB SG:
- Inbound: 443 (HTTPS) from 0.0.0.0/0
- Inbound: 80 (HTTP) from 0.0.0.0/0
- Outbound: All to App Server SG

App Server SG:
- Inbound: 8080 from ALB SG only
- Outbound: 443 to 0.0.0.0/0 (API calls)
- Outbound: 3306 to Database SG

Database SG:
- Inbound: 3306 from App Server SG only
- Outbound: None (no outbound needed)

ðŸ’¼ REAL-WORLD USE CASES
This VPC architecture supports:

ðŸŒ 3-tier web applications (web, app, database)
ðŸ”„ Microservices architectures
ðŸ“Š Data processing pipelines
ðŸ¢ Enterprise applications with compliance requirements
ðŸ” PCI-DSS, HIPAA, SOC 2 compliant workloads


ðŸŽ“ SKILLS DEMONSTRATED
âœ… Network Architecture - CIDR planning, subnet design, routing
âœ… Security Engineering - Network segmentation, least privilege
âœ… High Availability - Multi-AZ deployments, redundancy
âœ… Infrastructure as Code - Terraform for repeatable builds
âœ… Cost Optimization - Understanding NAT Gateway costs
âœ… AWS Best Practices - Following Well-Architected Framework

ðŸ”— RELATED PROJECTS
Check out my other AWS infrastructure projects:

â˜ï¸ S3 + CloudFront Secure Hosting - Static site CDN
ðŸ“Š CloudWatch Proactive Monitoring - Infrastructure observability
ðŸ” GuardDuty Threat Response - Automated security


ðŸ“« CONNECT WITH ME
Show Image
Show Image
Show Image

<div align="center">
âš¡ Network design is the foundationâ€”everything else is built on top.
Show Image
</div>
## Lessons Learned
- Always commit small changes frequently.
- Document your code clearly.
- Test before pushing.
- Keep your branches organized.
- Continuous learning is key!

> NOTE: This project was [REMOVED] temporarily for demonstration purposes. No live endpoints exist.


> NOTE: This project was  temporarily for demonstration purposes. No live endpoints exist.


NOTE: This project was  temporarily for demonstration purposes and is no longer live.


# aws_mult_itier_vpc_cloud_ops

⚡ **Project Overview**  
This repository contains the aws_mult_itier_vpc_cloud_ops project. All resources and scripts were built for learning, demonstration, and personal experimentation. Screenshots or examples may have been created, but this project is **not a live site**.

**Disclaimer:**  
> NOTE: This project was deployed temporarily for learning or demonstration purposes. No live site is currently available.

---

## 🔗 Links

- LinkedIn: [Charles Bucher](https://www.linkedin.com/in/charles-bucher85813)
- Repository: [GitHub](https://github.com/charles-bucher/aws_mult_itier_vpc_cloud_ops)

---

## 🏗️ Features / Highlights

- Feature 1: Short description
- Feature 2: Short description
- Feature 3: Short description

---

## 🛠️ Tech Stack

- Tech 1
- Tech 2
- Tech 3

---

## 🎓 Skills Demonstrated

- Skill 1
- Skill 2
- Skill 3

---

## 📋 Usage

1. Clone the repository:
\\\ash
git clone https://github.com/charles-bucher/aws_mult_itier_vpc_cloud_ops.git
\\\
2. Follow instructions in the code or scripts to test locally.

---

## 💼 Notes

- Educational/demo purposes only.  
- Screenshots exist to show functionality or output.  
- No sensitive credentials or live endpoints are included.
