#!/bin/bash

# เครื่องมือที่จำเป็น (Ubuntu/Debian)
echo "⚙️ Installing power optimization tools (TLP and tuned)..."
sudo apt update
sudo apt install tlp tlp-rdw tuned -y

# การตั้งค่า TLP สำหรับการประหยัดพลังงานสูงสุด ---
echo "📄 Applying TLP configuration..."

# เปิดใช้งานการประหยัดพลังงานสำหรับ CPU
sudo tlp set default CPU_SCALING_GOVERNOR_ON_AC=powersave
sudo tlp set default CPU_SCALING_GOVERNOR_ON_BAT=powersave
sudo tlp set default CPU_ENERGY_PERF_POLICY_ON_AC=power
sudo tlp set default CPU_ENERGY_PERF_POLICY_ON_BAT=power

# เปิดใช้งานการประหยัดพลังงานสำหรับ Wi-Fi และบลูทูธ
sudo tlp set default WIFI_PWR_ON_AC=on
sudo tlp set default WIFI_PWR_ON_BAT=on
sudo tlp set default WOL_DISABLE=Y # ปิด Wake-on-LAN

# เปิดใช้งานการจัดการพลังงานของ SATA/HDD (ถ้ามี)
sudo tlp set default DISK_AUTOSUSPEND=1

# เปิดใช้งาน TLP daemon
echo "🚀 Enabling TLP service..."
sudo systemctl enable tlp
sudo systemctl start tlp

# การตั้งค่าTuned Profile ---
echo "📉 Enabling tuned 'powersave' profile..."
sudo tuned-adm profile powersave

# --- 4. การจัดการ Services ที่ไม่จำเป็น (Optional but recommended) ---
echo "🛑 Disabling unnecessary services..."

# ปิด Bluetooth service ถ้าไม่ใช้งาน
sudo systemctl stop bluetooth
sudo systemctl disable bluetooth

# ปิด Modem Manager 
sudo systemctl stop ModemManager
sudo systemctl disable ModemManager

# ปิด CUPS (Printing service)
sudo systemctl stop cups
sudo systemctl disable cups

# การปรับแต่ง Kernel Parameter (ผ่าน TLP/Tuned)
echo "🔌 Enabling USB autosuspend..."
echo 'OPTIONS="$OPTIONS USB_AUTOSUSPEND=1"' | sudo tee -a /etc/default/tlp > /dev/null

# การรายงานผล
echo "✅ Low Power Optimization Setup Complete."
echo "💡 Restart the system for full effect, then run 'sudo tlp-stat -b' to check battery/power status."

exit 0
