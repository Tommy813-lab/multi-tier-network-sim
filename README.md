Multi-Tier Network Simulation
This project is a hands-on simulation of a realistic multi-tier network architecture. It’s designed to give anyone — from students to cloud professionals — a clear view of how layered cloud environments are structured and secured. The project combines architecture diagrams, threat modeling, automation scripts, and a screenshot generator so you can visualize your network setup instantly.

If you want to learn cloud architecture and security in a practical way, this project is a strong starting point.

What’s Inside
Realistic Network Design — Simulates a three-tier structure: Web layer, Application layer, and Data layer.

Visual Assets — Architecture diagrams and network flow charts that clearly explain how the tiers connect.

Security Insights — Threat modeling document covering vulnerabilities and mitigation strategies.

Automation Scripts — Tools to deploy, clean up, and capture screenshots of the simulation.

Project Structure
multi-tier-network-sim/
│
├── diagrams/
│   ├── architecture-diagram.png
│   └── network-flow.png
│
├── scripts/
│   ├── deploy.sh
│   ├── cleanup.sh
│   └── screenshot.sh
│
├── threat_model.md
├── README.md
└── LICENSE
How to Use
Requirements
Linux or macOS environment

Git

Docker (optional for containerized simulation)

AWS CLI (optional for cloud deployment)

Steps
Clone the project:

git clone https://github.com/charles-bucher/multi-tier-network-sim.git
cd multi-tier-network-sim
Explore the /diagrams folder to review existing architecture and flow charts.

Review threat_model.md for detailed security considerations.

Deploy the simulation:

./scripts/deploy.sh
Capture screenshots of the simulation or diagrams:

./scripts/screenshot.sh
Clean up resources:

./scripts/cleanup.sh
Screenshot Script Details
screenshot.sh automatically captures visuals of your simulation and saves them to /diagrams/screenshots/. This helps document network states at different stages and creates reusable assets for presentations and reports.

Example usage:

./scripts/screenshot.sh
Output location:

diagrams/screenshots/
Who This Helps
This project is valuable for:

Cloud Architects planning multi-tier networks.

Security Engineers learning threat modeling.

DevOps Teams testing deployment automation.

Students & Enthusiasts seeking hands-on cloud networking practice.

What You’ll Learn
How to design and map multi-tier architectures.

How to visually document network flows.

How to apply threat modeling to real-world networks.

How to automate deployment and screenshot generation.

License
MIT License — see LICENSE file.

Contact
Charles Bucher
📧 
📞 727-520-5966
🔗 www.linkedin.com/in/charles-bucher-26598728b
🔗 Github:https://github.com/charles-bucher

