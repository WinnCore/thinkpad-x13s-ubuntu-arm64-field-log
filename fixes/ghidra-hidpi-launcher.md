# Fix: Ghidra HiDPI Launcher

## Problem

Ghidra can appear too small on Linux HiDPI displays because it is a Java/Swing application.

## Java Options

```bash
-Dsun.java2d.uiScale=2.5
-Dswing.aatext=true
-Dawt.useSystemAAFontSettings=on
```

## Notes

Desktop launcher issues may involve:

- `.desktop` file permissions
- trusted launcher behavior
- correct `Exec=`
- correct `Icon=`
- correct Ghidra path
