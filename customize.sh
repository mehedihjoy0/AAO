#!/system/bin/sh

# Grab information from module.prop
MODNAME=$(grep '^name=' $MODPATH/module.prop | cut -d= -f2-)
VERSION=$(grep '^version=' $MODPATH/module.prop | cut -d= -f2-)
AUTHOR=$(grep '^author=' $MODPATH/module.prop | cut -d= -f2-)

# Architecture detection and binary installation
ARCH=$(getprop ro.product.cpu.abi)
case "$ARCH" in
    *arm64*|*aarch64*)
        mv $MODPATH/system/bin/busybox.arm64 $MODPATH/system/bin/busybox
        mv $MODPATH/system/bin/sqlite3.arm64 $MODPATH/system/bin/sqlite3
        ;;
    *armeabi*|*armv7*)
        mv $MODPATH/system/bin/busybox.arm $MODPATH/system/bin/busybox
        mv $MODPATH/system/bin/sqlite3.arm $MODPATH/system/bin/sqlite3
        ;;
    *x86_64*)
        mv $MODPATH/system/bin/busybox.x64 $MODPATH/system/bin/busybox
        mv $MODPATH/system/bin/sqlite3.x64 $MODPATH/system/bin/sqlite3
        ;;
    *x86*)
        mv $MODPATH/system/bin/busybox.x86 $MODPATH/system/bin/busybox
        mv $MODPATH/system/bin/sqlite3.x86 $MODPATH/system/bin/sqlite3
        ;;
    *) exit 1 ;;
esac

# Cleanup unused binaries
rm -f $MODPATH/system/bin/busybox.* $MODPATH/system/bin/sqlite3.*


# Display info
ui_print "            "
ui_print "✨ Installing"
sleep 2
ui_print "┌───────────────────────────────────┐"
ui_print "|                                         |"
ui_print "|     $MODNAME      |"                
ui_print "|                $VERSION                  |"           
ui_print "|             $AUTHOR              |"
ui_print "|                                         |"
ui_print "└───────────────────────────────────┘"   

sleep 1 
ui_print " "  
ui_print " 📢 This module will:"  
sleep 1
ui_print "  ⏰ - Schedule daily optimization at 3️⃣:0️⃣0️⃣ AM"  
sleep 1
ui_print "  ✂️ - Trim TRIM-capable filesystems"  
sleep 1
ui_print "  🗑️ - Clear app caches (without deleting data)"  
sleep 1
ui_print "  🧹 - Clean system temp, logs, ANRs, tombstones"  
sleep 1
ui_print "  📊 - Optimize SQLite databases"  
sleep 1
ui_print "  🧠 - Drop kernel pagecache and free memory"  
sleep 1
ui_print "  🖼️ - Clear media thumbnails"  
sleep 1
ui_print "  🔄 - Reset ZRAM swap if available"  
sleep 1
ui_print " "  
ui_print " 📝 Check daily logs into /data/local/optimize.log"  
sleep 1
ui_print "✨ Installation Finished"  
ui_print " "
sleep 1


# Set permissions for files
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
set_perm $MODPATH/system/bin/sqlite3 0 0 0755
set_perm $MODPATH/system/bin/busybox 0 0 0755
set_perm $MODPATH/optimize.sh 0 0 0755
set_perm $MODPATH/uninstall.sh 0 0 0755

# Move service script into service.d
mkdir -p /data/adb/service.d
mv -f $MODPATH/android_optimizer.sh /data/adb/service.d
set_perm /data/adb/service.d/android_optimizer.sh 0 0 0755

# Clear Dalvik-cache
find /data/dalvik-cache -type f -delete