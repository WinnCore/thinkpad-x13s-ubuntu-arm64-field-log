# Power, Suspend, and Freeze Notes

## Main Issue

The machine experienced random freezes, black-screen behavior, and hard shutdown-like crashes.

## Strong Clue

Journal logs showed unclean shutdown behavior, including corrupted or replaced journal files after reboot.

## Working Theory

The problem appears connected to suspend / sleep-state handling rather than simple overheating.

Possible contributors:

- Qualcomm platform sleep-state behavior
- GNOME power settings
- `systemd-logind`
- lid switch handling
- suspend target behavior
- firmware / kernel maturity on ARM64 laptops

## Current Workaround

Avoid suspend aggressively.

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

sudo reboot
```

## Warning

Restarting `systemd-logind` from inside the active graphical session may destabilize or freeze the desktop. Reboot instead.
