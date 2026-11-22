#!/bin/bash
# 在 feeds update 之前执行，cwd = 源码根目录（Airoha/）
# 把驱动 feed 从 pbs05（无修复）切换到 rayniel 的 XG-PON 诊断分支

echo ">>> pon_drivers before:"
grep pon_drivers feeds.conf.default || true

sed -i 's#https://github.com/pbs05/openwrt-pon-drivers.git#https://github.com/rayniel/openwrt-pon-drivers.git^rayniel/an7583-xgpon-diagnostics#' feeds.conf.default

echo ">>> pon_drivers after:"
grep pon_drivers feeds.conf.default
