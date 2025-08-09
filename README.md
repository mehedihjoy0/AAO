<div align="center">
  <img src="https://raw.githubusercontent.com/mehedihjoy0/AAO/main/banner.jpg" alt="AAO Banner"/>
</div>

## 🤖 Automatic Android Optimizer (AAO)  
**👨‍💻 Author:** @mehedihjoy0  

---  

### 📖 Overview  

The **Automatic Android Optimizer** is a Magisk/KernelSU/APatch module that performs a comprehensive set of maintenance tasks on your rooted Android device on every night at **🕒 03:00 AM**. It trims filesystems, clears caches and logs, optimizes databases, resets ZRAM, and more—🚀 automatically, with zero user interaction after installation.  

---  

### 🏗️ Supported Architectures 

- **armeabi-v7a** (32-bit ARM)  
- **arm64-v8a** (64-bit ARM)  
- **x86** (32-bit Intel)  
- **x86_64** (64-bit Intel)  

---

### 🛠️ Features  

1. **✂️ Trim Filesystems**: Runs `fstrim` on all TRIM-capable partitions (`/data`, `/cache`, `/system`, `/vendor`, etc.).  
2. **🗑️ Clear App Caches**: Deletes `*cache*` folders in `/data/data` and `/sdcard/Android/data` while preserving app data.  
3. **🧽 Clean System Temp**: Purges `/cache/*`, `/data/local/tmp/*`, and junk files.  
4. **🧠 Optimize Memory**: Drops kernel pagecache, dentries, and inodes to free up RAM.  
5. **💾 Database Optimization**: Vacuums and reindexes all SQLite databases under `/data/data`.  
6. **📜 System Log Cleanup**: Removes system logs, tombstones, ANR traces, and Dropbox entries.  
7. **🖼️ Thumbnail Purge**: Clears media thumbnails in DCIM and Pictures folders.  
8. **🌀 ZRAM Reset**: If ZRAM is available, resets the swap device, recreates swap, and re-enables it.  

---  

### 📂 Module Structure  

```
AAO/                          # 🏠 Module root (placed under Magisk's modules folder)  
├── customize.sh              # ⚙️ Installation script (service.d deploy)  
├── android_optimizer.sh      # ⏰ Scheduler (moved to /data/adb/service.d)  
├── optimize.sh               # 🛠️ Core maintenance script  
├── system/bin/  
│   ├── sqlite3               # 🗃️ SQLite binary for DB operations  
│   └── busybox               # 🧰 BusyBox for utility commands  
├── uninstall.sh              # 🧹 Cleanup on module removal  
└── module.prop               # 📜 Module properties (ID, name, version, etc.)  
```  

---  

### ⚙️ Installation  

1. **📥 Flash the Module**: Install via Magisk/KernelSU/APatch.  
2. **🔃 Reboot**: Reboot to activate.  

After reboot, the scheduler will wait for boot completion, then run `optimize.sh` daily at **🕒 03:00 AM** automatically.  

---  

### 🔧 Configuration  

* **📝 Log File**: Maintenance logs are saved to `/data/local/optimize.log`.  
* **⏲️ Scheduler**: Runs hourly checks and executes once daily at 03:00 AM.  

No extra setup needed! To change the run time, edit `android_optimizer.sh` before installing.  

---  

### 📝 Usage & Logs  

* **📋 View Logs**:  
  ```sh  
  cat /data/local/optimize.log  
  ```  

---  

### ❌ Uninstallation  

1. **🗑️ Remove Module**: Remove via Magisk/KernelSU/APatch.  
2. **🔃 Reboot**: Ensures all tasks are stopped.  

---  

### 📜 License  

Licensed under the [MIT License](https://opensource.org/licenses/MIT). 🎉 Fork, tweak, and share!  

---  

### 📦 Credits  

- **SQLite3**: Public domain binary from [sqlite.org](https://sqlite.org)  
- **BusyBox**: Statically linked binary from [BusyBox](https://busybox.net) (GNU GPL licensed)  

---  

### 💬 Support  

For issues or feature requests, reach out:  

**📘 Facebook**: [Mehedi H Joy](https://facebook.com/mehedihjoy0)  
**📱 Telegram**: [Mehedi H Joy](https://t.me/mehedihjoy0)  
**🐙 GitHub Issues**  

Happy optimizing! 🚀✨  