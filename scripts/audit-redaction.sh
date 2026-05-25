#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
FAIL=0

echo "[*] Auditing likely private values in: $TARGET"

while IFS= read -r -d '' file; do
  case "$file" in
    */.git/*) continue ;;
    */private-do-not-publish/*) continue ;;
  esac

  perl -ne '
    if (
      /[A-Za-z0-9._%+-]+@gmail\.com/ ||
      /Machine ID:\s*(?!MACHINE_ID_REDACTED\b)[0-9a-fA-F]{16,}/ ||
      /Serial Number:\s*(?!SERIAL_REDACTED\b)[A-Za-z0-9][A-Za-z0-9._:-]*/ ||
      /SerialNumber:\s*(?!SERIAL_REDACTED\b)[A-Za-z0-9][A-Za-z0-9._:-]*/ ||
      /(?:[0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}/ ||
      /\b192\.168\.[0-9]{1,3}\.[0-9]{1,3}\b/ ||
      /\b10\.0\.[0-9]{1,3}\.[0-9]{1,3}\b/ ||
      /\b172\.16\.[0-9]{1,3}\.[0-9]{1,3}\b/
    ) {
      print "$ARGV:$.:$_";
      $bad = 1;
    }
    END { exit($bad ? 1 : 0) }
  ' "$file" || FAIL=1

done < <(find "$TARGET" -type f -print0)

if [ "$FAIL" -eq 1 ]; then
  echo
  echo "[!] Possible private values found. Review before publishing."
  exit 1
else
  echo "[+] Clean: no obvious private values found."
fi
