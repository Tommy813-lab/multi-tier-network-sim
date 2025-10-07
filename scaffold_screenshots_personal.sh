#!/bin/bash

echo "🛠 Charles here — kicking off my custom scaffold for multi-tier-network-sim…"

# Step 1 — Ensure screenshot folders exist
if [ ! -d "docs/screenshots" ]; then
    mkdir -p docs/screenshots
    echo "✅ Created screenshots folder at docs/screenshots/"
else
    echo "ℹ️ Screenshot folder already exists."
fi

# Step 2 — Add a personal recruiter-friendly section to README
if ! grep -q "## 📸 Screenshots" README.md; then
cat >> README.md <<EOL

---

## 📸 Screenshots — Charles’s Recruiter Reminder
This project is built to demonstrate advanced multi‑tier network design with real-world AWS practices.

Here’s the visual proof recruiters should see:
- Architecture diagram → docs/screenshots/architecture.png  
- Simulation result → docs/screenshots/simulation_result.png  
- Terraform deployment output → docs/screenshots/terraform_output.png  

*(Charles reminder: Add screenshots after deployment to impress recruiters)*

EOL
    echo "📄 Updated README.md with recruiter-friendly screenshot section."
else
    echo "ℹ️ README already contains screenshot section."
fi

# Step 3 — Create placeholder screenshots if they don’t exist
for file in architecture.png simulation_result.png terraform_output.png; do
    if [ ! -f "docs/screenshots/$file" ]; then
        touch "docs/screenshots/$file"
        echo "📸 Created placeholder: docs/screenshots/$file"
    else
        echo "ℹ️ Placeholder already exists: docs/screenshots/$file"
    fi
done

echo "🚀 Charles’s scaffold fix is complete — recruiter‑ready!"
