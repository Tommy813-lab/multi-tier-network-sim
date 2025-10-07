# Multi-Tier Network Simulation

![license](https://img.shields.io/github/license/Tommy813-lab/multi-tier-network-sim)
![last-commit](https://img.shields.io/github/last-commit/Tommy813-lab/multi-tier-network-sim)
![terraform](https://img.shields.io/badge/Terraform-validated-blueviolet)

---

## TL;DR
A simulated **three-tier AWS network** (web, app, database) built with **Terraform**.  
Demonstrates secure VPC design with public/private subnets, NAT gateways, routing tables, and least-privilege security groups.

**Tech Stack:** Terraform · AWS VPC · EC2 · Subnets · NAT Gateway · Security Groups  
**Skills Demonstrated:** Infrastructure as Code, cloud networking, segmentation, IAM best practices, secure subnet routing

---

## Features
- **Tiered Subnet Layout:** Public, private, and database tiers with proper routing and NAT for controlled internet access.  
- **Segmentation & Security:** Security groups and routing enforce traffic flow web → app → database.  
- **Reusable IaC:** Terraform modules for subnets, routing, and instance provisioning.  
- **Documentation:** Includes a network diagram to visualize the architecture.  
- **Cost-Aware:** Uses small/free-tier EC2 instances, with teardown instructions to prevent surprise charges.  

---

## Quick Start
```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy (may incur AWS costs)
terraform apply

# Tear down when finished
terraform destroy




🔑 Key Highlights

✅ 3-Tier Architecture: Core, distribution, and access layers with routing and segmentation
✅ DMZ + Security: Public web tier, firewalls, ACLs, and VPN tunneling
✅ Cloud-Friendly: Infrastructure as Code (Terraform/Ansible) templates for repeatable builds
✅ Monitoring \& Logging: SNMP, syslog, and traffic flow analysis
✅ Redundancy \& Scaling: Load balancers, failover testing, and HA concepts
✅ Automation Ready: Configs version-controlled and reproducible





\## 🧠 AWS SAA Certification Mapping



This project aligns with key domains of the AWS Certified Solutions Architect – Associate exam:



\- \*\*Secure Architectures\*\*: DMZ, VPN, ACLs, NAT, firewall rules

\- \*\*Resilient Architectures\*\*: Load balancers, failover routing, multi-tier design

\- \*\*High-Performing Architectures\*\*: VLANs, traffic flow optimization, SNMP/syslog monitoring

\- \*\*Cost-Optimized Architectures\*\*: Terraform modules, Docker lab setup, GNS3 simulation

\- \*\*Implementation\*\*: IaC via Terraform + Ansible, CI/CD automation, monitoring scripts





⚙️ Tech Stack

Networking: VLANs, OSPF/BGP, NAT, ACLs, firewalls



Virtualization: GNS3, Docker, (optional: Packet Tracer)

IaC / Automation: Terraform + Ansible (sample templates provided)



Monitoring: Syslog server, SNMP traps, Netflow exports



Security: DMZ, VPN, access control policies



📂 Project Structure
multi-tier-network-sim/
│
├── docs/             # Network diagrams, design notes, explanations
├── configs/          # Router, switch, firewall configurations
├── terraform/        # Infrastructure as Code for cloud-like builds
├── ansible/          # Automation playbooks (config deployment)
├── docker/           # Containerized lab setup
├── monitoring/       # Logging/monitoring configs
└── README.md         # You are here

🌐 Example Topology

Core Layer → 2x Routers (OSPF/BGP, redundancy)

Distribution Layer → L3 Switches (inter-VLAN routing, policy enforcement)

Access Layer → Client LANs (PCs, servers, IoT)

DMZ → Public web server with firewall + NAT rules

Monitoring → Centralized syslog, SNMP trap collector, flow monitoring

📖 Think of this as a scaled-down enterprise setup you’d see in a mid-size company.



⚡ Quick Start
Dockerized Lab (Fast Setup)
git clone https://github.com/Tommy813-lab/multi-tier-network-sim.git
cd multi-tier-network-sim
docker-compose up -d

GNS3 Topology (Detailed Simulation)

Open multi-tier.gns3project in GNS3

Start routers, switches, and endpoints

Apply configs from /configs

Test connectivity + routing between tiers



📊 Roadmap

Core, Distribution, Access layer simulation

VLANs, routing, ACLs

Full DMZ implementation (public web + NAT)

VPN tunneling \& advanced firewall rules

Load balancing \& HA testing

Complete Terraform + Ansible automation



🎯 Why This Project Matters

For Job Seekers → Demonstrates practical network design + automation skills

For Students → Serves as a step-by-step lab to practice multi-tier networking

For Professionals → Sandbox for testing IaC-driven networking concepts

This is not just a lab — it’s a portfolio-ready showcase proving you can design, deploy, and automate complex networking environments.



🤝 Contributing

Pull requests welcome — more topologies, automation scripts, or monitoring integrations would make this repo even more powerful.



📜 License

MIT License — free to use, modify, and share.


## ?? Repo Hygiene Summary
- Cleaned artifacts and renamed files for recruiter polish.


<!-- Badges -->
![Cert Alignment](https://img.shields.io/badge/cert-AWS-blue)
![Repo Type](https://img.shields.io/badge/type-Infrastructure-green)
![Last Updated](https://img.shields.io/badge/updated-2025--09--30-orange)


## Badges
[![AWS Certified](https://img.shields.io/badge/AWS-Certified-blue)](https://aws.amazon.com/certification/)

---

## 📸 Screenshots
Recruiters want proof you built this project:
- Architecture diagram: docs/screenshots/architecture.png
- Simulation result: docs/screenshots/simulation_result.png
- Terraform output: docs/screenshots/terraform_output.png

*(Reminder: Add these screenshots after deployment)*


---

## 📸 Screenshots — Charles’s Recruiter Reminder
This project is built to demonstrate advanced multi‑tier network design with real-world AWS practices.

Here’s the visual proof recruiters should see:
- Architecture diagram → docs/screenshots/architecture.png  
- Simulation result → docs/screenshots/simulation_result.png  
- Terraform deployment output → docs/screenshots/terraform_output.png  

*(Charles reminder: Add screenshots after deployment to impress recruiters)*

