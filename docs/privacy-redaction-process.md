# Privacy and Redaction Process

Before any system logs, package dumps, or diagnostic outputs are committed to this repository, they must pass through a strict redaction pipeline.

## Redacted Targets
The following information is scrubbed from all published files:
- Real MAC addresses
- Private IPv4/IPv6 addresses
- Machine IDs
- Hardware Serial Numbers
- Usernames and hostnames
- Email addresses (e.g., Gmail)
- WiFi SSIDs and network keys

## Safe Placeholders
Redacted strings are replaced with explicit, uppercase placeholders such as:
- `MAC_REDACTED`
- `IPV4_REDACTED`
- `MACHINE_ID_REDACTED`
- `SERIAL_REDACTED`

This ensures that the structure of the logs remains intact for troubleshooting context without leaking the physical identity of the test machine.
