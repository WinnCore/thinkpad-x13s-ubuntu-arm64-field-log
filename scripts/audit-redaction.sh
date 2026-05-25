#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
echo "[*] Auditing files in: $TARGET"

MAC_REGEX="\b([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}\b"
IP192_REGEX="\b192\.168\.[0-9]{1,3}\.[0-9]{1,3}\b"
IP10_REGEX="\b10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b"
IP172_REGEX="\b172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}\b"
GMAIL_REGEX="\b[a-zA-Z0-9._%+-]+@gmail\.com\b"
MACHINE_ID_REGEX="\b[a-f0-9]{32}\b"

COMBINED="$MAC_REGEX|$IP192_REGEX|$IP10_REGEX|$IP172_REGEX|$GMAIL_REGEX|$MACHINE_ID_REGEX"

if grep -r -n -E "$COMBINED" \
    --exclude-dir=".git" \
    --exclude-dir="private-do-not-publish" \
    --exclude="audit-redaction.sh" \
    "$TARGET"; then
    echo
    echo "[!] Possible private values found. Review output above."
    exit 1
else
    echo "[+] Clean: no known private values found."
fi
