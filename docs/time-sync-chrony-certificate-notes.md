# Time Sync, Chrony, and Certificate Notes

## Problem

Logs showed repeated `chronyd` TLS handshake failures against Ubuntu NTP servers.

Example pattern:

```text
chronyd: TLS handshake failed
certificate verification failed
certificate chain uses expired certificate
