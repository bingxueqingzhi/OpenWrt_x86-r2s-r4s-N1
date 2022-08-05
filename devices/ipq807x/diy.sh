#!/bin/bash
shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))
bash $SHELL_FOLDER/../common/kernel_5.15.sh
	
rm -rf package/boot/uboot-envtools package/firmware/ipq-wifi package/firmware/ath11k* package/kernel/mac80211 package/qca package/qat

svn export --force https://github.com/Boos4721/openwrt/trunk/package/boot/uboot-envtools package/boot/uboot-envtools
svn export --force https://github.com/Boos4721/openwrt/trunk/package/firmware/ipq-wifi package/firmware/ipq-wifi
svn export --force https://github.com/Boos4721/openwrt/trunk/package/firmware/ath11k-board package/firmware/ath11k-board
svn export --force https://github.com/Boos4721/openwrt/trunk/package/firmware/ath11k-firmware package/firmware/ath11k-firmware
svn export --force https://github.com/Boos4721/openwrt/trunk/package/qca package/qca
svn export --force https://github.com/Boos4721/openwrt/trunk/package/qat package/qat

svn export --force https://github.com/Boos4721/openwrt/trunk/package/boot/uboot-envtools package/boot/uboot-envtools
svn co https://github.com/Boos4721/openwrt/trunk/target/linux/ipq807x target/linux/ipq807x
svn co https://github.com/Boos4721/openwrt/trunk/target/linux/generic/pending-5.15 target/linux/generic/pending-5.15
curl -sfL https://raw.githubusercontent.com/Boos4721/openwrt/master/package/kernel/linux/modules/netsupport.mk -o package/kernel/linux/modules/netsupport.mk
curl -sfL https://raw.githubusercontent.com/Lstions/openwrt-boos/master/target/linux/ipq807x/patches-5.15/608-5.15-qca-nss-ssdk-delete-fdb-entry-using-netdev -o target/linux/ipq807x/patches-5.15/608-5.15-qca-nss-ssdk-delete-fdb-entry-using-netdev.patch

function git_sparse_clone() (
          commitid="$1" rurl="$2" localdir="$3" && shift 3
          git clone --filter=blob:none --sparse $rurl $localdir
          cd $localdir
		  git checkout $commitid
          git sparse-checkout init --cone
          git sparse-checkout set $@
          mv -n $@ ../
          cd ..
          rm -rf $localdir
          )

git_sparse_clone 6ae0b47c024869f14ef85d140060eacd5a868b1e "https://github.com/Boos4721/openwrt" "bmac80211" package/kernel/mac80211
mv -f mac80211 package/kernel/


sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += luci-app-turboacc/' target/linux/ipq807x/Makefile

echo '
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
' >> ./target/linux/ipq807x/config-5.15
