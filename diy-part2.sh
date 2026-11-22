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

# Replace luci-theme-argon
rm -rfv feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

# Remove luci-app-argon-config if exists
if [ -d feeds/luci/applications/luci-app-argon-config ]; then
  echo "Found luci-app-argon-config, removing ..."
  rm -rfv feeds/luci/applications/luci-app-argon-config
else
  echo "luci-app-argon-config not found, skip"
fi

# ===== 启用 XG-PON stock BWmap 兼容（rayniel 分支）=====
echo ">>> patch driver default xgpon_stock_bwmap=true"
SRC=$(find feeds -path '*airoha-xpon/src/airoha-xpon-xgpon.c' | head -1)
echo "SRC=$SRC"
if [ -n "$SRC" ] && grep -q 'xgpon_stock_bwmap' "$SRC"; then
  sed -i 's/^static bool xgpon_stock_bwmap;/static bool xgpon_stock_bwmap = true;/' "$SRC"
  grep -n 'xgpon_stock_bwmap = true' "$SRC"
  sed -i 's/^PKG_RELEASE:=73$/PKG_RELEASE:=74/' feeds/pon_drivers/airoha-xpon/Makefile 2>/dev/null || true
else
  echo "WARN: 未找到 xgpon_stock_bwmap，驱动分支可能未切换成功"
fi
