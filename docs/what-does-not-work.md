# What Does Not Work or Is Unstable

- Random freeze or shutdown-like behavior
- Suspend / sleep behavior appears risky
- Restarting systemd-logind from inside the graphical session can destabilize the desktop
- Firefox / Discord may trigger graphics-related instability
- Flatpak can fail if GLib or LD_LIBRARY_PATH is broken
- Qualcomm-related kernel warnings appear in logs
- Some third-party APT repositories may not support Ubuntu ARM64 cleanly
- Built-in WiFi is not ideal for monitor mode / packet injection workflows
- Chrony certificate / NTP TLS errors appeared in logs and need separate testing

## Rule

Do not assume this machine behaves like a normal x86_64 Ubuntu laptop.
