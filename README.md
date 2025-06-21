# immortalwrt-mt7981-rax3000m_nand 云编译仓库

需要使用 hanwckf 版 uboot：https://github.com/hanwckf/bl-mt798x

* 默认整合所有路由基础功能(`pppoe`、`ipv6`、`防火墙`等)，其他功能均会在`Release`简介处列出。
* 建议使用`Releases`内最新且标注“已测试”的固件。
* 编译istore需要注意: 近期由于kenzo仓库添加了istore,导致和237仓库既有的istore的app在编译时冲突，请编译时注意在diy-part2.sh中加入命令删除某些重复的软件包。

 ### 鸣谢
 以下排名不分先后<br />
 
 固件:<br />
 [`immortalwrt`](https://github.com/immortalwrt/immortalwrt)
 [`openwrt`](https://github.com/openwrt/openwrt)
 [`padavanonly`](https://github.com/padavanonly/immortalwrt-mt798x/tree/openwrt-21.02)
 [`hanwckf`](https://github.com/hanwckf/immortalwrt-mt798x)
 [`coolsnowwolf`](https://github.com/coolsnowwolf/lede)
 <br />
 
 Github Actions:<br />
 [`P3TERX`](https://github.com/P3TERX/Actions-OpenWrt)
 [`zikura88`](https://github.com/zikura88/build-immortalwrt-mt798x-rax3000m-256m)
 [`Hyy2001X`](https://github.com/Hyy2001X/AutoBuild-Actions-Template)
 [`lgs2007m`](https://github.com/lgs2007m/Actions-OpenWrt)
 [`Huanyueyichen`](https://github.com/Huanyueyichen/build-openwrt)
 [`mzwrt`](https://github.com/mzwrt/MZwrt-RAx3000m-nand-Lite)
 [`281677160`](https://github.com/281677160/build-actions)
 [`klever1988`](https://github.com/klever1988/cachewrtbuild)
