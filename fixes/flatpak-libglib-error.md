# Fix: Flatpak GLib Shared Library Error

## Error

```text
flatpak: error while loading shared libraries: libglib-2.0.so.0: cannot open shared object file
```

## Test Without LD_LIBRARY_PATH

```bash
env -u LD_LIBRARY_PATH flatpak --version
```

## Find Suspicious Local GLib Files

```bash
find "$HOME" -name 'libglib-2.0.so*' -ls 2>/dev/null
```

## Check LD_LIBRARY_PATH

```bash
echo "$LD_LIBRARY_PATH"
```

## Safer Pattern

```bash
export LD_LIBRARY_PATH="/some/path${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```
