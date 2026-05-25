# ThinkPad X13s Gen 1 Ubuntu ARM64 Field Log

> A practical, monolithic field log documenting the architecture, stability, and quirks of running Ubuntu on the Qualcomm Snapdragon SC8280XP platform.

## Table of Contents
- [Project Purpose](#project-purpose)
- [Machine Class](#machine-class)
- [System Rebuild Checklist](#system-rebuild-checklist)
- [Hardware & Architecture](#hardware--architecture)
  - [Device Tree (DTB) Extraction](#device-tree-dtb-extraction)
  - [Thermal & Battery Baseline](#thermal--battery-baseline)
- [Stability & Subsystem Fixes](#stability--subsystem-fixes)
  - [Power, Suspend, and Freezes](#power-suspend-and-freezes)
  - [Graphics, Firefox, and Discord](#graphics-firefox-and-discord)
  - [LD_LIBRARY_PATH and GLib](#ld_library_path-and-glib)
  - [Virtualization (KVM)](#virtualization-kvm)
  - [APT Repository Quirks](#apt-repository-quirks)
- [Known Kernel Warnings](#known-kernel-warnings)
- [Quick Diagnostic Commands](#quick-diagnostic-commands)
- [Acknowledgments & Credits](#acknowledgments--credits)

---

## Project Purpose
This repository documents real troubleshooting work on a ThinkPad X13s Gen 1 running Ubuntu on ARM64. It is not a universal install guide. It is a technical field log documenting what works, what breaks, and how the Linux kernel interacts with this specific mobile architecture.

## Machine Class
| Item | Value |
|---|---|
| **Device family** | Lenovo ThinkPad X13s Gen 1 |
| **Architecture** | ARM64 / aarch64 |
| **Platform** | Qualcomm Snapdragon (SC8280XP / 8cx Gen 3) |
| **Operating system** | Ubuntu Linux |

---

## System Rebuild Checklist
If wiping this machine and reinstalling Ubuntu ARM64 from scratch, follow this baseline sequence:

1. **Base Install:** Complete standard Ubuntu ARM64 installation.
2. **Suspend Block:** Immediately apply the `systemd-logind` drop-in to disable suspend/lid triggers and prevent hard freezes. (Reboot, do not restart `systemd-logind` from GUI).
3. **Graphics Fallback:** Apply the software rendering workaround (`LIBGL_ALWAYS_SOFTWARE=1`) if Firefox/Wayland freezes the desktop.
4. **Environment Check:** Ensure `.bashrc` does not have a trailing colon in `LD_LIBRARY_PATH` to avoid GLib crashes.
5. **HiDPI Scaling:** Configure Java/Swing UI scaling flags for tools like Ghidra.
6. **Network:** Use an external USB WiFi adapter for security/monitor-mode labs.

---

## Hardware & Architecture

### Device Tree (DTB) Extraction
ARM64 systems rely on a Device Tree Blob (DTB) passed to the kernel at boot to define memory mapping, IRQ routing, and hardware configuration. To read it:

```bash
sudo apt install device-tree-compiler
cp /sys/firmware/fdt /tmp/x13s-active.dtb
dtc -I dtb -O dts -o ~/Projects/x13s-active.dts /tmp/x13s-active.dtb
