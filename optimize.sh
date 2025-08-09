#!/system/bin/sh
#
# Automatic Android Optimizer Script
#

#----------------------------------
# Define module directory (MODDIR)
#----------------------------------
MODDIR="${0%/*}"

LOG_FILE="/data/local/optimize.log"

# Helper: timestamp function
TIMESTAMP() { date "+%Y-%m-%d %H:%M:%S"; }

#--------------------------------------------------
# 1) Trim TRIM-capable filesystems
#--------------------------------------------------
trim_filesystems() {
    echo "[1/8] Trimming filesystems at $(TIMESTAMP)"
    for part in /data /cache /system /system_ext /vendor /product; do
        if mount | grep -q " on $part "; then
            echo "  Trimming $part..."
            busybox fstrim -v "$part" 2>&1 | grep -v "Inappropriate ioctl"
        else
            echo "  Skipping $part (not mounted)"
        fi
    done
}

#--------------------------------------------------
# 2) Clear app-level caches (preserve app data)
#--------------------------------------------------
clear_app_caches() {
    echo "[2/8] Clearing app caches at $(TIMESTAMP)"
    for base in "/data/data" "/sdcard/Android/data"; do
        [ -d "$base" ] || { echo "  $base not found"; continue; }
        echo "  Scanning $base for cache folders..."
        find "$base" -type d -iname "*cache*" -print0 | while IFS= read -r -d '' dir; do
            echo "    Deleting $dir"
            rm -rf "$dir"
        done
    done
}

#--------------------------------------------------
# 3) Clean system temp & cache directories
#--------------------------------------------------
clean_system_temp() {
    echo "[3/8] Cleaning system temp at $(TIMESTAMP)"
    rm -rf /cache/* /data/local/tmp/* /data/cache/*
    
}

#--------------------------------------------------
# 4) Drop kernel pagecache, dentries, inodes (memory)
#--------------------------------------------------
optimize_memory() {
    echo "[4/8] Optimizing memory at $(TIMESTAMP)"
    echo "  Before:"
    free -h 2>/dev/null || cat /proc/meminfo | grep -E "MemFree|Buffers|Cached"

    sync
    echo 3 > /proc/sys/vm/drop_caches

    echo "  After:"
    free -h 2>/dev/null || cat /proc/meminfo | grep -E "MemFree|Buffers|Cached"
}

#--------------------------------------------------
# 5) Vacuum (optimize) user databases
#--------------------------------------------------
optimize_databases() {
    echo "[5/8] Optimizing databases at $(TIMESTAMP)"
    find /data/data -type f -name "*.db" | while read -r db; do
        [ -f "$db" ] || continue
        if head -c 15 "$db" 2>/dev/null | grep -q "SQLite format 3"; then
            echo "  Vacuuming $db"
            sqlite3 "$db" 'VACUUM; REINDEX;' \
                2>&1 | grep -vE "collation|locked|file is not a database"
        fi
    done
}

#--------------------------------------------------
# 6) Clear system logs, tombstones, ANRs
#--------------------------------------------------
clear_system_logs() {
    echo "[6/8] Clearing system logs & tombstones at $(TIMESTAMP)"
    rm -rf /data/log/*
    rm -rf /data/system/dropbox/*
    rm -rf /data/tombstones/*
    rm -rf /data/anr/*
}

#--------------------------------------------------
# 7) Clear media thumbnails
#--------------------------------------------------
clear_media_thumbnails() {
    echo "[7/8] Clearing media thumbnails at $(TIMESTAMP)"
    rm -rf /sdcard/DCIM/.thumbnails/*
    rm -rf /sdcard/Pictures/.thumbnails/*
}

#--------------------------------------------------
# 8) Reset ZRAM swap if available
#--------------------------------------------------
zram_reset() {
    local zram="/sys/block/zram0/reset"
    if [ -f "$zram" ]; then
        echo "[8/8] Resetting ZRAM at $(TIMESTAMP)"
        echo 1 > "$zram"
        mkswap /dev/block/zram0
        swapon /dev/block/zram0
    else
        echo "[8/8] ZRAM device not found, skipping"
    fi
}

#--------------------------------------------------
# Final log footer
#--------------------------------------------------
log_footer() {
    echo "Optimization completed at $(TIMESTAMP)"
    echo "============================================"
}

#--------------------------------------------------
# Main Execution Block
#--------------------------------------------------
{
    echo "============================================"
    echo "=== Optimizing started at $(TIMESTAMP) ==="
    trim_filesystems
    clear_app_caches
    clean_system_temp
    optimize_memory
    optimize_databases
    clear_system_logs
    clear_media_thumbnails
    zram_reset
    log_footer
} >> "$LOG_FILE" 2>&1
