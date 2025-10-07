#!/bin/bash

echo "📦 Starting scaffold for multi-tier-network-sim repo..."

# Step 1 — Create screenshot folders if missing
[ ! -d "docs/screenshots" ] && mkdir -p docs/screenshots

echo "✅ Screenshot folder structure created."

# Step 2 — Add README reminder section if not present
if ! grep -q "## 📸 Screenshots" README.md; then
cat >> README.md <<EOL

---

## 📸 Screenshots
Recruiters want proof you built this project:
- Architecture diagram: docs/screenshots/architecture.png
- Simulation result: docs/screenshots/simulation_result.png
- Terraform output: docs/screenshots/terraform_output.png

*(Reminder: Add these screenshots after deployment)*

EOL
fi
echo "📄 README updated with screenshot reminders."

# Step 3 — Create placeholder screenshots
touch docs/screenshots/architecture.png
touch docs/screenshots/simulation_result.png
touch docs/screenshots/terraform_output.png

echo "📸 Screenshot placeholders created in docs/screenshots/"

echo "🎯 Scaffold complete."

