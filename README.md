# ThinkPad X13s Gen 1 Ubuntu ARM64 Field Log

A field log for running Ubuntu on a Lenovo ThinkPad X13s Gen 1 ARM64 / Snapdragon laptop.

This is not a universal Linux install guide. It is a record of real problems, workarounds, warnings, and lessons from one ARM64 laptop setup.

## Why This Exists

ARM64 laptops do not behave like normal Intel/AMD Linux laptops.

On this platform, success depends on:

- exact laptop model
- Qualcomm firmware support
- kernel version
- Ubuntu version
- suspend and sleep-state behavior
- GPU/browser rendering path
- package repository architecture support
- desktop environment behavior

Most generic Linux advice assumes x86_64. This repo documents what actually happened on this machine.

## Machine Class

| Item | Value |
|---|---|
| Laptop | Lenovo ThinkPad X13s Gen 1 |
| Architecture | ARM64 / aarch64 |
| Platform | Qualcomm Snapdragon |
| OS | Ubuntu |
| Focus | Stability, suspend, freezes, firmware warnings, graphics issues, package compatibility |

## Main Problem Areas

1. Random freezes and hard shutdown-like crashes
2. GNOME / systemd suspend conflict
3. Qualcomm power-management and firmware warnings
4. Firefox / Discord graphics instability
5. GLib / `LD_LIBRARY_PATH` breakage
6. Flatpak shared-library failure
7. Ghidra HiDPI launcher setup
8. APT repository compatibility on Ubuntu ARM64
9. KVM / virtualization limitations
10. Internal WiFi limitations for security testing

## Repo Map

```text
PROBLEMS_AND_FIXES.md
docs/
  power-suspend-freeze-notes.md
  graphics-firefox-discord-notes.md
  ld-library-path-glib-notes.md
  known-kernel-warnings.md
  package-repository-notes.md
  virtualization-notes.md
fixes/
  disable-suspend-logind-dropin.md
  firefox-discord-software-rendering.md
  flatpak-libglib-error.md
  ghidra-hidpi-launcher.md
  apt-repository-cleanup.md
scripts/
  audit-redaction.sh
  collect-safe-system-info.sh
system-snapshots/
  redacted snapshots only
```

## Privacy Rule

Before publishing logs, redact:

- usernames
- hostnames
- emails
- serial numbers
- machine IDs
- MAC addresses
- IP addresses
- WiFi SSIDs
- tokens or keys

Run:

```bash
./scripts/audit-redaction.sh .
```

## Status

This repo is a working field log. Some issues are understood well enough to document as workarounds. Others are still observed warnings that need more testing before calling them root causes.
