#!/bin/bash
# Download the HuMSub database (index 1) from Zenodo
# This is required for the pipeline to run

set -euo pipefail

DB_URL="https://zenodo.org/records/15862096/files/HuMSub_51_1000.sbt.zip?download=1"
DB_FILE="HuMSub_51_1000.sbt.zip"

if [ -f "$DB_FILE" ]; then
    echo "Database $DB_FILE already exists. Skipping download."
    exit 0
fi

echo "Downloading HuMSub database (132 MB)..."
curl -L -o "$DB_FILE" "$DB_URL"
echo "Download complete: $(ls -lh $DB_FILE | awk '{print $5}')"
