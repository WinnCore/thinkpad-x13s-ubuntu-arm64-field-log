# ThinkPad X13s Gen 1 Ubuntu ARM64 Field Log

> A practical field log documenting the architecture, stability, and quirks of running Ubuntu on the Qualcomm Snapdragon SC8280XP platform.

## Project Purpose

This repository documents real troubleshooting work on a ThinkPad X13s Gen 1 running Ubuntu on ARM64. It is not a universal install guide. It is a technical field log documenting what works, what breaks, and how the Linux kernel interacts with this specific mobile architecture.

## Machine Class

| Item | Value |
|---|---|
| **Device family** | Lenovo ThinkPad X13s Gen 1 |
| **Architecture** | ARM64 / aarch64 |
| **Platform** | Qualcomm Snapdragon (SC8280XP / 8cx Gen 3) |
| **Operating system** | Ubuntu Linux |

## Repository Index

### Core Documentation
- [Problems & Fixes Matrix](PROBLEMS_AND_FIXES.md)
- [System Rebuild Checklist](docs/rebuild-checklist.md)
- [Privacy & Redaction Process](docs/privacy-redaction-process.md)

### Hardware & Architecture Notes
- [Device Tree (DTB) Extraction](docs/device-tree-notes.md)
- [Thermal & Battery Baseline](docs/thermal-battery-baseline-notes.md)
- [Known Kernel & Firmware Warnings](docs/known-kernel-warnings.md)

### Stability & Subsystem Investigations
- [Power, Suspend, and Freeze Notes](docs/power-suspend-freeze-notes.md)
- [Graphics, Firefox, and Discord Notes](docs/graphics-firefox-discord-notes.md)
- [LD_LIBRARY_PATH and GLib Notes](docs/ld-library-path-glib-notes.md)
- [Package Repository Compatibility](docs/package-repository-notes.md)
- [Virtualization on ARM64](docs/virtualization-notes.md)

### Project Administration
- [Contributing Guidelines](CONTRIBUTING.md)
- [Acknowledgments](ACKNOWLEDGMENTS.md)
- [Credits](CREDITS.md)

## Quick Diagnostic Commands

```bash
lscpu
uname -a
journalctl -b -p err --no-pager
sudo dmesg | grep -iE "qcom|qualcomm|snapdragon|firmware|pmic|glink|gpu|drm|wifi|suspend|error"
```

## Important Warning

Do not blindly apply fixes from this repository to other machines. ARM64 laptop support depends heavily on the exact machine, firmware, kernel version, and Qualcomm driver support.
