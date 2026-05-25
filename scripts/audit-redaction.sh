#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
FAIL=0

echo "[*] Auditing high-risk private values in: $TARGET"

while IFS= read -r -d '' file; do
  case "$file" in
    */.git/*) continue ;;
    */private-do-not-publish/*) continue ;;
    */scripts/audit-redaction.sh) continue ;;
  esac

  perl -ne '
    if (
      /[A-Za-z0-9._%+-]+@gmail\.com/ ||
      /Machine ID:\s*(?!MACHINE_ID_REDACTED\b)[0-9a-fA-F]{16,}/ ||
      /Serial Number:\s*(?!SERIAL_REDACTED\b)[A-Za-z0-9][A-Za-z0-9._:-]*/ ||
      /SerialNumber:\s*(?!SERIAL_REDACTED\b)[A-Za-z0-9][A-Za-z0-9._:-]*/ ||
      /(?:[0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}/ ||
      /\b192\.168\.[0-9]{1,3}\.[0-9]{1,3}\b/
    ) {
      print "$ARGV:$.:$_";
      $bad = 1;
    }
    END { exit($bad ? 1 : 0) }
  ' "$file" || FAIL=1

done < <(find "$TARGET" -type f -print0)

if [ "$FAIL" -eq 1 ]; then
  echo
  echo "[!] Possible high-risk private values found. Review before publishing."
  exit 1
else
  echo "[+] Clean: no high-risk private values found."
fi
