# ThinkPad X13s Gen 1 Ubuntu ARM64 Field Log

A practical field log for running Ubuntu on a Lenovo ThinkPad X13s Gen 1 ARM64 / Snapdragon laptop.

This repository documents real troubleshooting work on one ARM64 laptop setup. It is not a universal Linux install guide. It is a record of what worked, what broke, what warnings appeared, what fixes were tested, and what still needs more investigation.

## Why This Repo Exists

ARM64 laptops are different from normal Intel/AMD Linux laptops.

On x86_64 laptops, many Linux fixes are generic. On Snapdragon / ARM64 laptops, support can depend heavily on:

- exact laptop model
- Qualcomm platform support
- Ubuntu version
- kernel version
- firmware state
- ACPI / device-tree behavior
- suspend and sleep-state handling
- GPU / browser rendering paths
- package architecture support
- desktop environment behavior

This repo exists because exact-model troubleshooting notes are valuable. Even if another machine also uses a Snapdragon chip, it may behave differently.

## Machine Class

| Item | Value |
|---|---|
| Laptop | Lenovo ThinkPad X13s Gen 1 |
| Architecture | ARM64 / aarch64 |
| Platform | Qualcomm Snapdragon |
| Operating system | Ubuntu |
| Main focus | Stability, suspend behavior, firmware warnings, graphics issues, package compatibility |

## Main Problem Areas

1. Random freezes / hard shutoffs
2. Suspend and sleep instability
3. GNOME / systemd-logind power-management conflicts
4. Qualcomm firmware and kernel warnings
5. Firefox / Discord graphics instability
6. GLib / `LD_LIBRARY_PATH` breakage
7. Flatpak shared-library errors
8. Ghidra HiDPI scaling
9. APT repository compatibility on Ubuntu ARM64
10. Chrony / NTP certificate errors
11. KVM / virtualization limitations
12. Built-in WiFi limitations for security testing
13. Privacy-safe log collection and redaction

---

# Current Status

## What Works

- Ubuntu boots on ARM64 / aarch64
- Basic desktop environment works
- Terminal workflow works
- WiFi works through the current driver stack
- Git and project documentation workflow works
- Ghidra can be improved with HiDPI launcher options
- System logs can be collected and redacted for public documentation

## Needs Confirmation

- Long-term stability after suspend avoidance
- Flatpak behavior after GLib / `LD_LIBRARY_PATH` cleanup
- Browser stability under different rendering modes
- External display behavior
- Bluetooth reliability
- Camera functionality
- Battery reporting accuracy
- Which kernel version is most stable on this exact machine

## Known / Observed Issues

- Random freeze or shutdown-like behavior
- Suspend / sleep behavior appears risky
- Restarting `systemd-logind` from inside the graphical session can destabilize the desktop
- Firefox / Discord may trigger graphics-related instability
- Flatpak can fail if GLib or `LD_LIBRARY_PATH` is broken
- Qualcomm-related kernel warnings appear in logs
- Some third-party APT repositories may not support Ubuntu ARM64 cleanly
- Built-in WiFi is not ideal for monitor mode / packet injection workflows
- Chrony certificate / NTP TLS errors appeared in logs and need separate testing
- Local KVM virtualization may not be available or straightforward

Important rule:

Do not assume this machine behaves like a normal x86_64 Ubuntu laptop.

---

# 1. Random Freezes / Hard Shutoffs

## Symptoms

- Random freezes
- Black-screen behavior
- Shutdown-like crashes
- Journal entries showing unclean shutdowns or corrupted journal files

## Observed Clues

- `systemd-journald` messages after unclean shutdown
- Qualcomm-related kernel messages
- suspend / power-management behavior appearing near instability
- crashes did not look like simple overheating

## Working Theory

The strongest theory is a combination of:

- suspend / sleep-state instability
- Qualcomm platform firmware behavior
- GNOME power settings
- `systemd-logind`
- graphics stack instability
- ARM64 kernel / firmware maturity

This is not claimed as a proven root cause. It is the current working theory based on observed behavior.

## Status

Partially worked around by avoiding suspend behavior.

---

# 2. GNOME / systemd Suspend Conflict

## Symptoms

- System attempted to suspend even when suspend behavior was blocked
- Freeze or black-screen behavior
- `suspend.target` was masked or refused
- Journal logs showed unclean shutdown behavior after crashes

## Likely Cause

This appears related to suspend / sleep-state instability on the ThinkPad X13s Gen 1 ARM64 / Qualcomm platform.

The working theory is that Qualcomm laptop sleep states, firmware behavior, GNOME power management, and `systemd-logind` suspend handling may conflict on this setup.

## Fix / Workaround

Create this file:

```text
/etc/systemd/logind.conf.d/99-disable-suspend.conf


