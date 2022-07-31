#!/bin/bash

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += autocore-arm fdisk lsblk luci-app-cpufreq kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8152 kmod-usb2 kmod-usb3/' target/linux/bcm27xx/Makefile

sed -i 's/factory.img.gz //' target/linux/bcm27xx/image/Makefile

SHELL_FOLDER=$(dirname $(readlink -f "$0"))
bash $SHELL_FOLDER/../common/kernel_5.15.sh

echo '
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
' >> ./target/linux/bcm27xx/bcm2710/config-5.15
