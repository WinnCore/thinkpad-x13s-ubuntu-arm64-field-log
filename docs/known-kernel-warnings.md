# Known Kernel and Firmware Warnings

## Qualcomm Power / PMIC

Observed categories:

```text
qcom_pmic_glink
qcom-battmgr
pmic
```

Status: observed, not fully root-caused.

## Qualcomm APM / GPR Timeout

Example:

```text
qcom-apm gprsvc: CMD timeout
```

Status: observed warning. Needs correlation testing.

## USB / dwc3

Example category:

```text
dwc3
usb
```

Status: observed warning. Track whether it appears near device failures or freezes.

## Camera Clock

Example category:

```text
ov5675
xvclk
camera
```

Status: likely only important if camera functionality is broken.

## Useful Filter

```bash
sudo dmesg | grep -iE "qcom|qualcomm|snapdragon|firmware|pmic|glink|remoteproc|dwc3|usb|gpu|drm|wifi|camera|xvclk|thermal|battery|suspend|sleep|error|fail|warn"
```
