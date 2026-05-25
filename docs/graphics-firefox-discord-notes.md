# Graphics, Firefox, and Discord Notes

## Problem

Discord running inside Firefox caused freeze-like behavior on this ARM64 Ubuntu setup.

## Possible Cause

The issue may involve:

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

## Status

This is a workaround, not a root-cause fix.
