#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

## 删除冲突的软件包（近期由于kenzo仓库添加了istore,导致和237仓库既有的istore的app在编译时冲突）
#rm -rf ./package/istore
#rm -rf ./feeds/kenzo/luci-app-quickstart
#rm -rf ./feeds/kenzo/luci-app-store
#rm -rf ./feeds/kenzo/luci-lib-taskd

## 移除 SNAPSHOT 标签
#sed -i 's,SNAPSHOT,,g' include/version.mk
#sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## Modify default Lan IP
sed -i 's/192\.168\.[0-9]*\.[0-9]*/192.168.5.1/g' package/base-files/files/bin/config_generate

## Modify hostname
#sed -i "s/hostname='.*'/hostname='MzWrt'/g" package/base-files/files/bin/config_generate

## 启用 irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

## 修改wan口默认pppoe和设置pppoe拨号账户密码
if [[ -n "$PPPOE_USERNAME" && -n "$PPPOE_PASSWD" ]]; then
  sed -i 's/2:-dhcp/2:-pppoe/g' package/base-files/files/lib/functions/uci-defaults.sh

  sed -i "s#username='username'#username='$PPPOE_USERNAME'#g" package/base-files/files/bin/config_generate
  sed -i "s#password='password'#password='$PPPOE_PASSWD'#g" package/base-files/files/bin/config_generate
fi

## 修改wifi名称和用户名密码
# 如果是使用LUCI界面配置WiFi，也就是使用mtwifi-cfg
sed -i 's/ImmortalWrt-2.4G/RAX3000M/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
sed -i 's/ImmortalWrt-5G/RAX3000M-5G/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
# 如果是使用luci-app-mtk界面配置WiFi
sed -i "s#^SSID1=.*#SSID1=RAX3000M#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b0.dat
sed -i "s#^SSID1=.*#SSID1=RAX3000M-5G#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b1.dat
sed -i "s#^AuthMode=.*#AuthMode=WPA2PSK#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b{0,1}.dat
sed -i "s#^EncrypType=.*#EncrypType=AES#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b{0,1}.dat
sed -i "s#^PMFMFPC=.*#PMFMFPC=1#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b{0,1}.dat
sed -i "s#^RekeyMethod=.*#RekeyMethod=TIME#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b{0,1}.dat
sed -i "s#^WPAPSK1=.*#WPAPSK1=$WIFI_PASSWD#g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b{0,1}.dat

## 修改闪存为256M版本(这是针对原厂128闪存来的，但又要编译256M固件来的）
#sed -i 's/<0x580000 0x7200000>/<0x580000 0xee00000>/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m.dts
#sed -i 's/116736k/240128k/g' target/linux/mediatek/image/mt7981.mk

rm -rf package/new && mkdir -p package/new

## 下载最新版主题luci-theme-argon
# git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
# git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
## 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
# sed -i '/+luci-light/d;s/+luci-app-opkg/+luci-light/' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-openwrt/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
## 修改argon背景图片
rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## golang编译环境
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

## Add luci-app-wechatpush/v3.6.8
rm -rf feeds/luci/applications/luci-app-wechatpush/
git clone --depth 1 -b v3.6.8 https://github.com/tty228/luci-app-wechatpush.git package/new/luci-app-wechatpush

## Add luci-app-cloudflarespeedtest
git clone --depth 1 https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest.git package/new/luci-app-cloudflarespeedtest

## Add luci-app-socat
rm -rf feeds/packages/net/socat
git clone --depth 1 https://github.com/immortalwrt/packages package/new/immortalwrt-packages
mv package/new/immortalwrt-packages/net/socat package/new/socat
rm -rf package/new/immortalwrt-packages
rm -rf feeds/luci/applications/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/chenmozhijin-socat
mv -n package/new/chenmozhijin-socat/luci-app-socat package/new/
rm -rf package/new/chenmozhijin-socat


## Add luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash
#bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64
# bash $GITHUB_WORKSPACE/scripts/openclash-dev.sh arm64
git clone --depth 1 https://github.com/vernesong/OpenClash package/new/OpenClash
mv -n package/new/OpenClash/luci-app-openclash package/new/
rm -rf package/new/OpenClash
mkdir -p package/new/luci-app-openclash/root/etc/openclash/core

# CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz"
# CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/master/premium\?ref\=core | grep download_url | grep $1 | awk -F '"' '{print $4}' | grep -v "v3" )
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

# wget -qO- $CLASH_DEV_URL | tar xOvz > package/new/luci-app-openclash/root/etc/openclash/core/clash
# wget -qO- $CLASH_TUN_URL | gunzip -c > package/new/luci-app-openclash/root/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar -xOvz > package/new/luci-app-openclash/root/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > package/new/luci-app-openclash/root/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > package/new/luci-app-openclash/root/etc/openclash/GeoSite.dat

chmod +x package/new/luci-app-openclash/root/etc/openclash/core/clash*

## Add luci-app-qbittorrent/4.4.5
rm -rf feeds/luci/applications/luci-app-qbittorrent
rm -rf feeds/packages/net/qBittorrent-Enhanced-Edition
git clone --depth 1 -b 4.4.5 https://github.com/sbwml/luci-app-qbittorrent.git package/new/luci-app-qbittorrent

## Add zsh
#bash $GITHUB_WORKSPACE/scripts/zsh.sh
# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
# preset-terminal-tools
mkdir -p files/root
pushd files/root
# Install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh ./.oh-my-zsh
# Install extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ./.oh-my-zsh/custom/plugins/zsh-completions
# Get .zshrc dotfile
cp $GITHUB_WORKSPACE/patches/.zshrc .
popd

## 修改插件名字（待测试）
#grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
#grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
#grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
#grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
#grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
#grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
#grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
#grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
#grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'

## end
ls -1 package/new/

