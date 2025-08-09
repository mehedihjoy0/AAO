#!/system/bin/sh
#
# android_optimizer.sh — schedules optimize.sh daily at 03:00

# Path to the optimizer script
OPT="/data/adb/modules/AAO/optimize.sh"

# Spawn the scheduler loop in the background
(
  # 1) Wait for Android to finish booting
  until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 10
  done

  # 2) Loop forever, running maintenance at 03:00 am each day
  while true; do
    # Get hour in 24h format (00–23)
    HOUR=$(date +%H)

    if [ "$HOUR" = "03" ]; then
      sh "$OPT"
      # Prevent re-running in the same hour
      sleep 3600
    fi

    # Check again in 5 minutes
    sleep 300
  done
) &

# Exit immediately so Magisk doesn’t block or kill it
exit 0