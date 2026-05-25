# Thermal and Battery Baseline Notes

## Hardware Context
The Lenovo ThinkPad X13s Gen 1 features a fanless, passively cooled chassis built around the Qualcomm Snapdragon SC8280XP (8cx Gen 3) compute platform.

Because it lacks active cooling, system stability relies entirely on the kernel correctly interpreting thermal zones and scaling CPU frequencies dynamically via the Qualcomm Power Management IC (PMIC).

## Diagnostic Commands
To observe the power and thermal states, these tools are highly relevant on this architecture:

### 1. Read Raw Thermal Zones
```bash
cat /sys/class/thermal/thermal_zone*/type
cat /sys/class/thermal/thermal_zone*/temp
```

### 2. Monitor Battery Discharge Rate
```bash
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to empty|percentage|energy-rate"
```

### 3. Inspect Power States
```bash
sudo powertop --auto-tune
```
*(Note: `powertop` recommendations should be applied with caution on ARM64, as aggressive USB/PCIe auto-suspend can trigger the hard freezes documented in `power-suspend-freeze-notes.md`.)*

## Current Observations & Working Theory
- **Thermals:** The chassis remains remarkably cool under standard desktop loads. There is currently no evidence that the random system freezes are caused by thermal runaway or emergency thermal shutdowns.
- **Battery Life:** Idle power draw appears slightly higher on the mainline/Ubuntu kernel than it does on the native Windows ARM build. This suggests that some lower-level Qualcomm SoC sleep states (like S0ix) are not being fully reached or utilized by the Linux environment.
- **PMIC Warnings:** `dmesg` logs frequently show `qcom_pmic_glink` and `qcom-battmgr` messages. It is highly likely that battery reporting and power-state transitions are still maturing in the upstream kernel for this specific platform.

## Status
Needs sustained testing. Future audits should benchmark the exact `energy-rate` (in watts) during idle Wayland/X11 sessions.
