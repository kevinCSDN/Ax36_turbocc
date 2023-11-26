#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: 该文件默认的是在openwrt目录下操作
#

# Modify default IP
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/packages/net/chinadns-ng
rm -rf feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/xray-plugin
git clone https://github.com/sirpdboy/luci-app-netdata.git package/luci-app-netdata
git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#git clone https://github.com/messense/aliyundrive-webdav package/aliyundrive-webdav
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
