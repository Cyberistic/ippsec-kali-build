#!/bin/bash
set -e

BURP_JAR="/usr/share/burpsuite/burpsuite.jar"
CERT_OUT="/tmp/cacert.der"

# Sanity checks
if ! command -v java >/dev/null 2>&1; then
  echo "Java not installed"
  exit 1
fi

if [ ! -f "$BURP_JAR" ]; then
  echo "Burp JAR not found at $BURP_JAR"
  exit 1
fi

# Start Burp headless
java -Xmx1g -Djava.awt.headless=true -jar "$BURP_JAR" >/tmp/burp.log 2>&1 &
BURP_PID=$!

# Wait for Burp proxy to come up
for i in {1..30}; do
  if curl -sf http://127.0.0.1:8080/cert -o "$CERT_OUT"; then
    break
  fi
  sleep 2
done

# Ensure cert was actually fetched
if [ ! -s "$CERT_OUT" ]; then
  echo "Failed to retrieve Burp CA certificate"
  kill "$BURP_PID" 2>/dev/null || true
  exit 1
fi

# Stop Burp cleanly
kill "$BURP_PID"
wait "$BURP_PID" 2>/dev/null || true
