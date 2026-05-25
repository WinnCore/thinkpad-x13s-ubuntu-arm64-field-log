# System Rebuild Checklist

If wiping this machine and reinstalling Ubuntu ARM64 from scratch, follow this baseline sequence based on observed hardware behavior.

1. **Base Install:** Complete standard Ubuntu ARM64 installation.
2. **Suspend Block:** Immediately apply the `systemd-logind` drop-in to disable suspend/lid triggers and prevent hard freezes. (Do not restart `systemd-logind` from the GUI; reboot instead).
3. **Graphics Fallback:** If using Firefox and Discord, apply the software rendering workaround (`LIBGL_ALWAYS_SOFTWARE=1`) if Wayland/WebRender freezes the desktop.
4. **Environment Check:** Ensure `.bashrc` does not have a trailing colon in `LD_LIBRARY_PATH` to avoid GLib shared library crashes (e.g., Flatpak, UxPlay).
5. **HiDPI Scaling:** Configure Java/Swing UI scaling flags if running reverse engineering tools like Ghidra.
6. **Network:** Use an external USB WiFi adapter for security/monitor-mode labs, as the internal Snapdragon interface has limitations.
