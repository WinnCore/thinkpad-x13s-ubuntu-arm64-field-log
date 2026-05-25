#!/usr/bin/env bash
set -euo pipefail

OUT_ROOT="${1:-system-snapshots}"
SNAPDIR="$OUT_ROOT/snapshot-$(date +%Y-%m-%d_%H-%M-%S)"

mkdir -p "$SNAPDIR"/{hardware,kernel,packages,logs}

{
  echo "===== DATE ====="
  date
  echo
  echo "===== OS RELEASE ====="
  cat /etc/os-release
  echo
  echo "===== UNAME ====="
  uname -a
  echo
  echo "===== HOSTNAMECTL ====="
  hostnamectl
  echo
  echo "===== ARCH ====="
  arch
} > "$SNAPDIR/hardware/system-basic.txt"

{
  echo "===== LSCPU ====="
  lscpu
} > "$SNAPDIR/hardware/cpu.txt"

{
  echo "===== KERNEL VERSION ====="
  uname -r
  echo
  echo "===== KERNEL CMDLINE ====="
  cat /proc/cmdline
} > "$SNAPDIR/kernel/kernel-cmdline.txt"

{
  echo "===== APT SOURCES ====="
  find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \) -print -exec sed -n '1,160p' {} \;
} > "$SNAPDIR/packages/apt-sources.txt"

{
  echo "===== DMESG FILTERED ====="
  sudo dmesg | grep -iE 'qcom|qualcomm|snapdragon|firmware|acpi|dtb|pmic|glink|remoteproc|adreno|gpu|drm|wifi|wlan|bluetooth|usb|dwc3|camera|xvclk|thermal|battery|suspend|sleep|error|fail|warn' || true
} > "$SNAPDIR/logs/dmesg-filtered.txt" 2>&1

{
  echo "===== JOURNAL ERRORS THIS BOOT ====="
  journalctl -b -p err --no-pager
  echo
  echo "===== JOURNAL WARNINGS THIS BOOT ====="
  journalctl -b -p warning --no-pager
} > "$SNAPDIR/logs/journal-errors-warnings.txt" 2>&1

find "$SNAPDIR" -type f -print0 | xargs -0 perl -pi -e '
s/(Machine ID:\s*)[A-Za-z0-9]+/${1}MACHINE_ID_REDACTED/g;
s/(Serial Number:\s*)[^\n\r]+/${1}SERIAL_REDACTED/g;
s/(SerialNumber:\s*)[^\n\r]+/${1}SERIAL_REDACTED/g;
s/(?:[0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}/MAC_REDACTED/g;
s/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/IPV4_REDACTED/g;
s/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/UUID_REDACTED/g;
'

echo "Snapshot created: $SNAPDIR"
echo "Run: ./scripts/audit-redaction.sh \"$SNAPDIR\""
