#!/bin/bash
# screenshot.sh
# Captures screenshots of diagrams for documentation

OUTPUT_DIR="./diagrams/screenshots"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Example: capture architecture diagram
if [ -f "./diagrams/architecture-diagram.png" ]; then
    cp "./diagrams/architecture-diagram.png" "$OUTPUT_DIR/architecture-diagram-$(date +%Y%m%d%H%M%S).png"
    echo "Screenshot saved to $OUTPUT_DIR"
else
    echo "No architecture diagram found to screenshot."
fi

# Example: capture network flow diagram
if [ -f "./diagrams/network-flow.png" ]; then
    cp "./diagrams/network-flow.png" "$OUTPUT_DIR/network-flow-$(date +%Y%m%d%H%M%S).png"
    echo "Network flow screenshot saved to $OUTPUT_DIR"
else
    echo "No network flow diagram found to screenshot."
fi
