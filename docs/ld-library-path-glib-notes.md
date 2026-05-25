# LD_LIBRARY_PATH and GLib Notes

## Problem

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
find "$HOME" -name 'libglib-2.0.so*' -ls 2>/dev/null
```

## Safer Bashrc Pattern

```bash
export LD_LIBRARY_PATH="/some/path${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```
