#!/usr/bin/env bash
set -e

BURP_PORT=8080
OUT_CERT="/tmp/cacert.der"
TIMEOUT=90

echo "[*] Locating Burp Suite..."

# 1. Locate Burp launcher
BURP_BIN="$(command -v burpsuite || true)"
if [[ -z "$BURP_BIN" ]]; then
  echo "[!] burpsuite not found in PATH"
  exit 1
fi

# 2. Resolve the actual JAR from the launcher
BURP_JAR="$(grep -oE '/.*burp[^ ]+\.jar' "$BURP_BIN" | head -n1)"

if [[ ! -f "$BURP_JAR" ]]; then
  echo "[!] Failed to locate Burp JAR"
  exit 1
fi

echo "[+] Using Burp JAR: $BURP_JAR"

# 3. Ensure Java exists
if ! command -v java >/dev/null 2>&1; then
  echo "[!] Java is not installed"
  exit 1
fi

# 4. Start Burp headless and auto-accept license
echo "[*] Starting Burp headless..."
yes y | timeout "$TIMEOUT" java \
  -Djava.awt.headless=true \
  -jar "$BURP_JAR" >/tmp/burp.log 2>&1 &

BURP_PID=$!

# 5. Wait for proxy to come up
echo "[*] Waiting for Burp proxy on port $BURP_PORT..."
for i in {1..30}; do
  if curl -s "http://127.0.0.1:$BURP_PORT/cert" >/dev/null; then
    break
  fi
  sleep 2
done

# 6. Download CA cert
if curl -sf "http://127.0.0.1:$BURP_PORT/cert" -o "$OUT_CERT"; then
  echo "[+] Burp CA certificate saved to $OUT_CERT"
else
  echo "[!] Failed to retrieve Burp CA certificate"
  kill "$BURP_PID" 2>/dev/null || true
  exit 1
fi

# 7. Cleanup
kill "$BURP_PID" 2>/dev/null || true
sleep 2

echo "[✓] Burp CA extraction complete"
exit 0
