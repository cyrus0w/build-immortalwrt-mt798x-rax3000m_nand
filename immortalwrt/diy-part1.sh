#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> ./feeds.conf.default
#echo "src-git small https://github.com/kenzok8/small" >> ./feeds.conf.default
#sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
#echo "src-git OpenClash https://github.com/vernesong/OpenClash.git" >> ./feeds.conf.default

## 删除冲突的软件包（近期由于kenzo仓库添加了istore,导致和237仓库既有的istore的app在编译时冲突）
#rm -rf ./package/istore
#rm -rf ./feeds/kenzo/luci-app-quickstart
#rm -rf ./feeds/kenzo/luci-app-store
#rm -rf ./feeds/kenzo/luci-lib-taskd