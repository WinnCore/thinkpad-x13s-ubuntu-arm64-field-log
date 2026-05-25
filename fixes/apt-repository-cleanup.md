# Fix: APT Repository Cleanup Notes

## List APT Sources

```bash
find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \) -print -exec sed -n '1,160p' {} \;
```

## Update

```bash
sudo apt update
```

## Common Issues

- duplicate repository entries
- wrong Ubuntu codename
- unsupported ARM64 architecture
- Signed-By mismatch
- third-party repository not updated for current Ubuntu release
