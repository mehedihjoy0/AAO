#!/system/bin/sh

# AAO Module Uninstaller

# Remove the module
rm -f /data/adb/service.d/android_optimizer.sh
rm -f /data/local/optimize.log
rm -rf /data/adb/modules/AAO
rm -rf /data/adb/modules_update/AAO
echo "✅ AAO module uninstalled successfully"
exit 0