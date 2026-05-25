# Fix: Disable Suspend Triggers Through systemd-logind

## Create Drop-In Config

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

## Apply

```bash
sudo reboot
```

## Verify

```bash
systemd-analyze cat-config systemd/logind.conf
loginctl show-logind | grep -E 'HandleLidSwitch|HandlePowerKey|IdleAction'
```

## Optional Hard Block

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

Undo:

```bash
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
