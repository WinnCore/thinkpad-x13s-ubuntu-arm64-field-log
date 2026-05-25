# Problems and Fixes

This file tracks real problems encountered while running Ubuntu on a Lenovo ThinkPad X13s Gen 1 ARM64 / Snapdragon laptop.

## 1. Random Freezes / Hard Shutoffs

### Symptoms

- Random freezes
- Black-screen behavior
- Shutdown-like crashes
- Journal entries showing unclean shutdowns or corrupted journal files

### Observed Clues

- `systemd-journald` messages after unclean shutdown
- Qualcomm-related kernel messages
- suspend / power-management behavior near instability
- crashes did not look like simple overheating

### Current Understanding

The strongest theory is a combination of suspend, firmware, power management, and graphics-stack instability.

### Status

Partially worked around by avoiding suspend behavior.

---

## 2. GNOME / systemd Suspend Conflict

### Symptoms

- System attempted to suspend even when suspend behavior was blocked
- Freeze or black-screen behavior
- `suspend.target is masked, refusing operation`
- Journal logs showed unclean shutdown behavior after crashes

### Likely Cause

This appears related to suspend / sleep-state instability on the ThinkPad X13s Gen 1 ARM64 / Qualcomm platform.

Do not overstate this as confirmed unless the logs prove it. The working theory is that Qualcomm laptop sleep states, firmware behavior, GNOME power management, and `systemd-logind` suspend handling may conflict on this setup.

### Fix / Workaround

Create a `systemd-logind` drop-in file:

```bash
sudo mkdir -p /etc/systemd/logind.conf.d

sudo tee /etc/systemd/logind.conf.d/99-disable-suspend.conf >/dev/null <<'DROPIN'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
HandlePowerKey=ignore
IdleAction=ignore
DROPIN
```

Apply safely by rebooting:

```bash
sudo reboot
```

Avoid restarting `systemd-logind` from inside the active graphical session unless prepared for the desktop session to freeze or reset.

### Verify

```bash
systemd-analyze cat-config systemd/logind.conf
loginctl show-logind | grep -E 'HandleLidSwitch|HandlePowerKey|IdleAction'
```

### Optional Hard Block

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

Undo:

```bash
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

---

## 3. Restarting systemd-logind Can Freeze the Session

### Symptoms

Restarting `systemd-logind` from inside the graphical desktop caused session instability or freezing.

### Lesson

Prefer rebooting after power-management changes.

---

## 4. Firefox / Discord Freeze

### Symptoms

- Discord inside Firefox caused freeze-like behavior
- Graphics/Vulkan-related messages appeared in logs

### Workaround

```bash
LIBGL_ALWAYS_SOFTWARE=1 MOZ_WEBRENDER=0 MOZ_DISABLE_WAYLAND=1 firefox --safe-mode
```

### Current Understanding

This may point to ARM64 graphics/rendering stack instability involving Firefox, Wayland, WebRender, Vulkan, or GPU acceleration.

---

## 5. Qualcomm PMIC / Power Messages

### Symptoms

Logs included Qualcomm-related messages such as:

```text
qcom_pmic_glink
qcom-battmgr
pmic
```

### Status

Observed but not fully root-caused.

---

## 6. Qualcomm APM / GPR Timeout

### Symptoms

Logs showed Qualcomm service timeout messages such as:

```text
qcom-apm gprsvc: CMD timeout
```

### Status

Observed warning. Needs correlation testing before claiming it causes freezes.

---

## 7. USB / dwc3 Errors

### Symptoms

Kernel messages included USB / `dwc3` related warnings.

### Status

Observed warning. Track whether these appear near freezes, shutdowns, suspend failures, or device disconnects.

---

## 8. Camera Clock / ov5675 xvclk Messages

### Symptoms

Camera-related kernel warning involving `ov5675` and `xvclk`.

### Status

Probably only important if camera functionality is broken.

---

## 9. UxPlay / GLib Error

### Symptoms

UxPlay or related tools failed with GLib shared-library errors:

```text
libglib-2.0.so.0: file too short
libglib-2.0.so.0: cannot open shared object file
```

### Root Cause Pattern

Problematic `LD_LIBRARY_PATH` behavior and bad local `libglib-2.0.so.0` files.

### Debug Commands

```bash
echo "$LD_LIBRARY_PATH"
env -u LD_LIBRARY_PATH command_name
find "$HOME" -name 'libglib-2.0.so*' -ls 2>/dev/null
```

---

## 10. Flatpak GLib Error

### Symptoms

Flatpak failed with:

```text
flatpak: error while loading shared libraries: libglib-2.0.so.0: cannot open shared object file
```

### Likely Cause

Probably related to the same GLib / `LD_LIBRARY_PATH` issue.

### Debug Command

```bash
env -u LD_LIBRARY_PATH flatpak --version
```

---

## 11. Ghidra HiDPI Scaling

### Problem

Ghidra looked too small or uncomfortable on a HiDPI Linux desktop.

### Workaround

Use Java/Swing scaling options:

```bash
-Dsun.java2d.uiScale=2.5
-Dswing.aatext=true
-Dawt.useSystemAAFontSettings=on
```

---

## 12. APT Repository Issues

### Problem

Third-party repositories may behave badly on Ubuntu ARM64 or newer Ubuntu releases.

Relevant examples:

- NodeSource Node.js 20.x
- Waydroid
- Metasploit
- Brave
- Microsoft / VS Code
- CS50 packagecloud repo

### Lesson

Not every repo supports every Ubuntu codename or ARM64 cleanly.

---

## 13. KVM / Virtualization Limitation

### Problem

Local KVM virtualization was not available or not straightforward on ThinkPad X13s ARM64.

### Workarounds

- QEMU user emulation
- cloud ARM VM
- non-KVM emulation
- native ARM64 packages where possible

---

## 14. Internal WiFi Limitation for Security Testing

### Problem

Built-in Snapdragon WiFi is not ideal for monitor mode / packet injection.

### Workaround

Use an external USB WiFi adapter that supports monitor mode and injection.

---

## Still Needs More Testing

- Whether Qualcomm PMIC messages correlate with freezes
- Whether `dwc3` errors correlate with USB instability
- Whether Firefox/Discord freezes are Wayland, WebRender, Vulkan, or GPU-driver related
- Whether suspend avoidance fully prevents hard shutoffs
- Whether Flatpak GLib error disappears after cleaning `LD_LIBRARY_PATH`
- Which kernel version is most stable on this exact machine
