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
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# 增加ax3600 stock布局
git remote add upstream https://github.com/zhkong/openwrt-ipq807x.git
git fetch upstream xiaomi-ax3600-stock-layout --depth 3
git cherry-pick e2bb765
git cherry-pick 6f6eb1d
#如果checkout失败，说明有冲突，停止编译
if [ $? -ne 0 ]; then
    echo "cherry-pick failed, please check"
    exit 1
fi

# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 添加第三方软件包
## openclash
git clone https://github.com/vernesong/OpenClash.git --single-branch --depth 1 package/new/luci-openclash
## argon theme
git clone https://github.com/jerrykuku/luci-theme-argon.git --single-branch --depth 1 package/new/luci-theme-argon
## KMS激活
#svn export https://github.com/immortalwrt/luci/branches/master/applications/luci-app-vlmcsd package/new/luci-app-vlmcsd
#svn export https://github.com/immortalwrt/packages/branches/master/net/vlmcsd package/new/vlmcsd
# edit package/new/luci-app-vlmcsd/Makefile
#sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' package/new/luci-app-vlmcsd/Makefile

## mosdns
# git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/mosdns
# git clone https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata

# AutoCore
svn export https://github.com/immortalwrt/immortalwrt/branches/master/package/emortal/autocore package/new/autocore
sed -i 's/"getTempInfo" /"getTempInfo", "getCPUBench", "getCPUUsage" /g' package/new/autocore/files/luci-mod-status-autocore.json

rm -rf feeds/luci/modules/luci-base
rm -rf feeds/luci/modules/luci-mod-status
rm -rf feeds/packages/utils/coremark
rm -rf package/emortal/default-settings

svn export https://github.com/immortalwrt/luci/branches/master/modules/luci-base feeds/luci/modules/luci-base
svn export https://github.com/immortalwrt/luci/branches/master/modules/luci-mod-status feeds/luci/modules/luci-mod-status
svn export https://github.com/immortalwrt/packages/branches/master/utils/coremark package/new/coremark
svn export https://github.com/immortalwrt/immortalwrt/branches/master/package/emortal/default-settings package/emortal/default-settings
# svn export https://github.com/immortalwrt/immortalwrt/branches/openwrt-23.05/package/utils/mhz package/utils/mhz

# fix luci-theme-argon css


# 增加 oh-my-zsh
mkdir -p files/www/luci-static/argon/css
wget https://github.com/jerrykuku/luci-theme-argon/raw/master/htdocs/luci-static/argon/css/cascade.css -O files/www/luci-static/argon/css/cascade.css
wget https://github.com/jerrykuku/luci-theme-argon/raw/master/htdocs/luci-static/argon/css/dark.css -O files/www/luci-static/argon/css/dark.css

mkdir -p files/root

## Install oh-my-zsh
# Clone oh-my-zsh repository
git clone https://github.com/robbyrussell/oh-my-zsh files/root/.oh-my-zsh

# Install extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions files/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git files/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions files/root/.oh-my-zsh/custom/plugins/zsh-completions

# Get .zshrc dotfile
cp ../data/zsh/.zshrc ./files/root/.zshrc

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
