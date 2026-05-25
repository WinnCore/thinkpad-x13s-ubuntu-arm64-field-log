# Device Tree (DTB) Extraction and Notes

## ARM64 Hardware Discovery
Unlike x86 platforms that rely heavily on ACPI for hardware discovery, ARM64 systems like the Snapdragon SC8280XP rely on a Device Tree. The Device Tree Blob (DTB) is passed to the kernel at boot and defines the exact memory mapping, IRQ routing, and hardware configuration of the ThinkPad X13s.

When troubleshooting low-level kernel panics, PMIC (power) warnings, or missing hardware (like audio or cameras), inspecting the active Device Tree is required.

## Extracting the Active Device Tree
The active, compiled Device Tree Blob is exposed by the kernel in sysfs. You can extract it and decompile it into human-readable Device Tree Source (.dts) format.

### 1. Install the Device Tree Compiler
```bash
sudo apt update
sudo apt install device-tree-compiler
```

### 2. Copy the Blob from sysfs
```bash
cp /sys/firmware/fdt /tmp/x13s-active.dtb
```

### 3. Decompile the DTB to DTS
```bash
dtc -I dtb -O dts -o ~/Projects/x13s-active.dts /tmp/x13s-active.dtb
```

### 4. Inspect the Source
You can now open `~/Projects/x13s-active.dts` in a text editor to see exactly how the kernel maps the Snapdragon hardware.

## Warning on DTB Modification
While you can compile a modified `.dts` back into a `.dtb` and pass it to the bootloader via GRUB or systemd-boot, **do not do this blindly**. Passing a malformed Device Tree can hard-brick the boot sequence, requiring manual EFI recovery.
