# Virtualization Notes

## Problem

KVM virtualization may not be available or straightforward on this ARM64 ThinkPad setup.

## Check

```bash
ls -l /dev/kvm
```

## Workarounds

- QEMU user emulation
- cloud ARM VM
- non-KVM emulation
- native ARM64 packages where possible

## Lesson

ARM64 Linux laptop support is not just about CPU architecture. Boot level, firmware, and hypervisor availability matter.
