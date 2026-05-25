# Package Repository Notes

## Problem

Third-party APT repositories may not support every Ubuntu codename or ARM64 cleanly.

## Repositories Seen / Relevant

- NodeSource Node.js 20.x
- Waydroid
- Metasploit
- Brave
- Microsoft / VS Code
- CS50 packagecloud

## Common Failure Types

- unsupported Ubuntu codename
- missing ARM64 packages
- Signed-By conflicts
- duplicate repo definitions
- old repo name pointing at a new Ubuntu release
- 404 errors

## Commands

```bash
find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \) -print -exec sed -n '1,160p' {} \;
sudo apt update
```
