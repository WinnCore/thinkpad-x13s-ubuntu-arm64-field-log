
# ThinkPad X13s Gen 1 Ubuntu ARM64 Field Log

A practical field log for running Ubuntu on a Lenovo ThinkPad X13s Gen 1 ARM64 / Snapdragon laptop.

This repository documents real troubleshooting work on one ARM64 laptop setup. It is not a universal Linux install guide. It is a record of what worked, what broke, what warnings appeared, what fixes were tested, and what still needs more investigation.

The README is intentionally written as a monolith so readers do not have to click through multiple files to understand the project.

---

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
- boot method and available firmware interfaces

This repo exists because exact-model troubleshooting notes are valuable. Even if another machine also uses a Snapdragon chip, it may behave differently.

---

## Machine Class

| Item | Value |
|---|---|
| Laptop | Lenovo ThinkPad X13s Gen 1 |
| Architecture | ARM64 / aarch64 |
| Platform | Qualcomm Snapdragon |
| Operating system | Ubuntu |
| Main focus | Stability, suspend behavior, firmware warnings, graphics issues, package compatibility |

---

## Main Problem Areas

1. Random freezes / hard shutoffs
2. Suspend and sleep instability
3. GNOME / systemd-logind power-management conflicts
4. Qualcomm firmware and kernel warnings
5. Firefox / Discord graphics instability
6. GLib / `LD_LIBRARY_PATH` breakage
7. Flatpak shared-library errors
8. UxPlay / AirPlay-style discovery issues
9. Ghidra HiDPI scaling
10. APT repository compatibility on Ubuntu ARM64
11. Chrony / NTP certificate errors
12. KVM / virtualization limitations
13. Built-in WiFi limitations for security testing
14. Privacy-safe log collection and redaction
15. Rebuild checklist for future installs

---

## Current Status

### What Works

- Ubuntu boots on ARM64 / aarch64
- Basic desktop environment works
- Terminal workflow works
- WiFi works through the current driver stack
- Git and project documentation workflow works
- Ghidra can be improved with HiDPI launcher options
- System logs can be collected and redacted for public documentation
- GitHub documentation workflow works after local commit and push

### Needs Confirmation

- Long-term stability after suspend avoidance
- Flatpak behavior after GLib / `LD_LIBRARY_PATH` cleanup
- Browser stability under different rendering modes
- External display behavior
- Bluetooth reliability
- Camera functionality
- Battery reporting accuracy
- Which kernel version is most stable on this exact machine
- Whether chrony certificate errors are time-sync-only or related to broader system state

### Known / Observed Issues

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

This is not proven as the final root cause. It is documented as the current working theory.

## Fix / Workaround

Create this file:

```text
/etc/systemd/logind.conf.d/99-disable-suspend.conf
```

With this content:

```ini
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
HandlePowerKey=ignore
IdleAction=ignore
```

Apply safely by rebooting:

```bash
sudo reboot
```

Avoid restarting `systemd-logind` from inside the active graphical session unless prepared for the desktop session to freeze or reset.

## Verify

```bash
systemd-analyze cat-config systemd/logind.conf
loginctl show-logind | grep -E "HandleLidSwitch|HandlePowerKey|IdleAction"
```

## Optional Hard Block

If the machine still tries to suspend:

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

Undo:

```bash
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

## Lesson

On this setup, avoiding suspend may be more stable than trying to make sleep behave like a normal x86_64 laptop.

---

# 3. Restarting systemd-logind Can Freeze the Session

## Symptoms

Restarting `systemd-logind` from inside the graphical desktop caused session instability or freezing.

## Risky Command

```bash
sudo systemctl restart systemd-logind
```

## Safer Option

```bash
sudo reboot
```

## Lesson

Prefer rebooting after power-management changes. Restarting `systemd-logind` inside an active desktop session can disrupt the graphical login/session environment.

---

# 4. Firefox / Discord Graphics Instability

## Symptoms

- Discord inside Firefox caused freeze-like behavior
- Graphics / Vulkan-related messages appeared in logs
- Browser behavior appeared more stable when risky rendering paths were disabled

## Possible Cause

This may involve:

- Firefox hardware acceleration
- WebRender
- Wayland
- Vulkan
- GPU driver behavior
- ARM64 graphics stack maturity

## Workaround

```bash
LIBGL_ALWAYS_SOFTWARE=1 MOZ_WEBRENDER=0 MOZ_DISABLE_WAYLAND=1 firefox --safe-mode
```

## What This Does

| Setting | Purpose |
|---|---|
| `LIBGL_ALWAYS_SOFTWARE=1` | Forces software rendering |
| `MOZ_WEBRENDER=0` | Disables Firefox WebRender |
| `MOZ_DISABLE_WAYLAND=1` | Avoids Firefox’s Wayland path |
| `--safe-mode` | Starts Firefox with safer defaults |

## Status

This is a workaround, not a root-cause fix.

---

# 5. Qualcomm Firmware and Kernel Warnings

## Qualcomm PMIC / Power Messages

Observed categories:

```text
qcom_pmic_glink
qcom-battmgr
pmic
```

Status: observed, not fully root-caused.

## Qualcomm APM / GPR Timeout

Observed warning:

```text
qcom-apm gprsvc: CMD timeout
```

Status: observed warning. Needs correlation testing before claiming it causes freezes.

## USB / dwc3 Warnings

Observed category:

```text
dwc3
usb
```

Status: observed warning. Track whether it appears near freezes, shutdowns, suspend failures, or device disconnects.

## Camera Clock / ov5675 xvclk

Observed category:

```text
ov5675
xvclk
camera
```

Status: likely only important if camera functionality is broken.

## Useful Kernel Log Filter

```bash
sudo dmesg | grep -iE "qcom|qualcomm|snapdragon|firmware|pmic|glink|remoteproc|dwc3|usb|gpu|drm|wifi|camera|xvclk|thermal|battery|suspend|sleep|error|fail|warn"
```

## Lesson

A scary-looking kernel message is not automatically the cause of a crash. Track timing, repetition, and whether the message appears near an actual failure.

---

# 6. GLib / LD_LIBRARY_PATH Breakage

## Symptoms

Some programs failed with GLib shared-library errors.

Examples:

```text
libglib-2.0.so.0: file too short
libglib-2.0.so.0: cannot open shared object file
```

## Root Cause Pattern

A bad `LD_LIBRARY_PATH` or local broken `libglib-2.0.so.0` file can cause the dynamic linker to search the wrong location before system libraries.

A trailing colon in `LD_LIBRARY_PATH` can also be dangerous because it may cause the current directory to be searched.

## Debug Commands

```bash
echo "$LD_LIBRARY_PATH"
env -u LD_LIBRARY_PATH flatpak --version
find "$HOME" -name "libglib-2.0.so*" -ls 2>/dev/null
```

## Safer Bashrc Pattern

```bash
export LD_LIBRARY_PATH="/some/path${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```

## Lesson

One bad environment variable can break unrelated desktop tools.

---

# 7. Flatpak GLib Error

## Error

```text
flatpak: error while loading shared libraries: libglib-2.0.so.0: cannot open shared object file
```

## Likely Cause

Probably related to the same GLib / `LD_LIBRARY_PATH` issue.

## Test Without LD_LIBRARY_PATH

```bash
env -u LD_LIBRARY_PATH flatpak --version
```

If this works, the system package may not be the root issue. The environment is likely the problem.

## Status

Needs retesting after fully cleaning `LD_LIBRARY_PATH`.

---

# 8. UxPlay / AirPlay-Style Discovery

## Symptoms

- Device became visible from iPhone
- Connection still failed
- GLib-related library errors appeared in related testing

## Debug Commands

```bash
uxplay -n X13s -nh -d
sudo ufw status
systemctl is-active avahi-daemon
```

## Possible Fix Direction

```bash
sudo systemctl enable --now avahi-daemon
uxplay -n X13s -nh
```

## Status

Observed workflow. Needs separate testing.

---

# 9. Ghidra HiDPI Scaling

## Problem

Ghidra can appear too small on Linux HiDPI displays because it is a Java / Swing application.

## Workaround

Use Java / Swing scaling options in a launcher:

```bash
-Dsun.java2d.uiScale=2.5
-Dswing.aatext=true
-Dawt.useSystemAAFontSettings=on
```

## Desktop Launcher Notes

Launcher issues may involve:

- `.desktop` file permissions
- trusted launcher behavior
- correct `Exec` value
- correct `Icon` value
- correct Ghidra path
- Java options used at launch

## Status

Workaround documented and useful for Linux HiDPI Java/Swing apps.

---

# 10. APT Repository Issues on Ubuntu ARM64

## Problem

Third-party APT repositories may not support every Ubuntu codename or ARM64 cleanly.

## Repositories Seen / Relevant

- NodeSource Node.js 20.x
- Waydroid
- Metasploit
- Brave
- Microsoft / VS Code
- CS50 packagecloud repo

## Common Failure Types

- unsupported Ubuntu codename
- missing ARM64 packages
- `Signed-By` conflicts
- duplicate repo definitions
- old repo name pointing at a new Ubuntu release
- 404 errors

## Commands

```bash
find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \) -print -exec sed -n "1,160p" {} \;
sudo apt update
```

## Lesson

On ARM64 Ubuntu, a repo existing is not enough. It must support both the Ubuntu codename and the architecture.

---

# 11. Chrony / Time Sync / Certificate Errors

## Problem

Logs showed repeated `chronyd` TLS handshake failures against Ubuntu NTP servers.

Example pattern:

```text
chronyd: TLS handshake failed
certificate verification failed
certificate chain uses expired certificate
```

## Why It Matters

Certificate errors can happen when:

- system time is wrong
- CA certificates are stale or broken
- NTP / NTS configuration has issues
- network interception or proxying is interfering
- the machine is booting before time sync is stable

## Debug Commands

```bash
timedatectl
chronyc tracking
chronyc sources -v
systemctl status chrony --no-pager
journalctl -u chrony -b --no-pager
```

## Possible Fix Direction

```bash
sudo apt update
sudo apt install --reinstall ca-certificates chrony
sudo systemctl restart chrony
timedatectl
chronyc tracking
```

## Status

Observed in logs. Needs separate testing before being treated as a root cause of freezes.

---

# 12. KVM / Virtualization Limitation

## Problem

Local KVM virtualization may not be available or straightforward on this ARM64 ThinkPad setup.

## Check

```bash
ls -l /dev/kvm
```

## Workarounds

- QEMU user emulation
- cloud ARM VM
- non-KVM emulation
- native ARM64 packages where possible

## Lesson

ARM64 Linux laptop support is not just about CPU architecture. Boot level, firmware, and hypervisor availability matter.

---

# 13. Internal WiFi Limitation for Security Testing

## Problem

Built-in Snapdragon WiFi is not ideal for monitor mode / packet injection workflows.

## Workaround

Use an external USB WiFi adapter that supports monitor mode and injection.

## Note

This is a hardware workflow limitation, not necessarily a general Linux failure.

---

# 14. Privacy and Redaction Process

## Why This Matters

Linux logs can expose private machine details. Before publishing logs publicly, redact high-risk values.

## Redact

- usernames
- hostnames
- emails
- serial numbers
- machine IDs
- MAC addresses
- private IP addresses
- WiFi SSIDs
- tokens or keys

## Safe Replacement Values

These are safe to publish:

```text
USER_REDACTED
HOST_REDACTED
SERIAL_REDACTED
MACHINE_ID_REDACTED
MAC_REDACTED
IPV4_REDACTED
IPV6_REDACTED
UUID_REDACTED
```

## Audit

```bash
./scripts/audit-redaction.sh .
```

## Lesson

Redaction scripts can produce false positives. A value like `SERIAL_REDACTED` is safe. A real serial number is not.

---

# 15. Rebuild Checklist

Use this if rebuilding the machine or recreating this setup.

## 1. Capture System Identity

```bash
lscpu
cat /etc/os-release
uname -a
hostnamectl
```

## 2. Avoid Suspend Instability

Create this file:

```text
/etc/systemd/logind.conf.d/99-disable-suspend.conf
```

File contents:

```ini
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
HandlePowerKey=ignore
IdleAction=ignore
```

Then reboot:

```bash
sudo reboot
```

## 3. Check Logs After Boot

```bash
journalctl -b -p err --no-pager
journalctl -b -p warning --no-pager
sudo dmesg | grep -iE "qcom|qualcomm|snapdragon|firmware|pmic|glink|dwc3|gpu|drm|wifi|camera|thermal|suspend|sleep|error|fail|warn"
```

## 4. Check Time Sync

```bash
timedatectl
chronyc tracking
chronyc sources -v
```

## 5. Check GLib / LD_LIBRARY_PATH

```bash
echo "$LD_LIBRARY_PATH"
env -u LD_LIBRARY_PATH flatpak --version
find "$HOME" -name "libglib-2.0.so*" -ls 2>/dev/null
```

## 6. Redact Before Publishing

```bash
./scripts/audit-redaction.sh .
```

---

# What Still Needs More Testing

- Whether Qualcomm PMIC messages correlate with freezes
- Whether `dwc3` errors correlate with USB instability
- Whether Firefox / Discord freezes are Wayland, WebRender, Vulkan, or GPU-driver related
- Whether suspend avoidance fully prevents hard shutoffs
- Whether Flatpak GLib error disappears after fully cleaning `LD_LIBRARY_PATH`
- Which kernel version is most stable on this exact machine
- Whether chrony / certificate errors are time-sync-only or related to broader system state
- Whether camera warnings matter for real camera functionality
- Whether Bluetooth and external display behavior are reliable long-term

---

# Credits and Acknowledgments

This repository is based on hands-on troubleshooting on a Lenovo ThinkPad X13s Gen 1 ARM64 / Snapdragon laptop.

Thanks to the broader Linux ARM64, Ubuntu, ThinkPad Linux, Qualcomm Linux, systemd, chrony, fwupd, Mozilla Firefox, Ghidra, and open-source communities whose documentation and discussions helped guide the debugging process.

Some notes were organized with AI assistance, but the logs, commands, troubleshooting steps, and observed machine behavior came from real testing on the target laptop.

Specific people should only be named if their help was public or they gave permission to be credited.

## Upstream / Official Projects

- Linux kernel
- Ubuntu
- systemd
- chrony
- fwupd
- Mozilla Firefox
- Ghidra
- Lenovo ThinkPad support resources

## Community Areas

- ARM64 Linux laptop discussions
- ThinkPad Linux discussions
- Ubuntu troubleshooting discussions
- Qualcomm / Snapdragon Linux discussions

---

# Disclaimer

These notes describe one real ThinkPad X13s Gen 1 ARM64 Ubuntu setup.

Do not assume every command applies to every Snapdragon or ARM64 laptop. Check your exact machine, firmware, Ubuntu version, kernel version, boot setup, and logs.

This repo is a technical field log, not an official Lenovo, Ubuntu, Qualcomm, or Linux kernel support guide.

