# Fix: Firefox / Discord Safer Rendering Workaround

```bash
LIBGL_ALWAYS_SOFTWARE=1 MOZ_WEBRENDER=0 MOZ_DISABLE_WAYLAND=1 firefox --safe-mode
```

This disables risky graphics paths and forces safer rendering behavior.

It is slower, but useful for testing whether GPU / Wayland / WebRender is part of the problem.
