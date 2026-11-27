# Setup otomatis Modul Praktikum 9 - Diary App
# Jalankan dari folder mobile-programming:
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   .\setup.ps1
$ErrorActionPreference = "Continue"
$root = $PSScriptRoot

function Step($t) { Write-Host "`n== $t ==" -ForegroundColor Cyan }

# ---------- 1. Backend ----------
Step "1/4 Backend: npm install (diary-api)"
Push-Location "$root\diary-api"
npm install
Pop-Location

# ---------- 2. Database ----------
Step "2/4 Database: import schema.sql"
Write-Host "Pastikan MySQL (XAMPP/Server) sudah AKTIF. Lewati dengan Ctrl+C bila ingin import manual."
& "$root\diary-api\scripts\import-schema.ps1"

# ---------- 3. Mobile ----------
Step "3/4 Mobile: create-expo-app + Redux Toolkit"
$app = "$root\diary-app9"
$tmpName = "_diary-app9-tmp"
$tmp = "$root\$tmpName"

if (-not (Test-Path "$app\package.json")) {
  Push-Location $root
  npx create-expo-app@latest $tmpName --template tabs
  Pop-Location

  if (-not (Test-Path "$tmp\package.json")) {
    Write-Host "create-expo-app gagal. Cek koneksi internet lalu jalankan ulang setup.ps1." -ForegroundColor Red
    exit 1
  }

  # ganti folder app bawaan template dengan kode praktikum
  if (Test-Path "$tmp\app") { Remove-Item "$tmp\app" -Recurse -Force }
  Copy-Item "$app\app" "$tmp\app" -Recurse
  Copy-Item "$app\src" "$tmp\src" -Recurse
  Copy-Item "$app\.env.example" "$tmp\.env.example"
  if (Test-Path "$app\README.md") { Copy-Item "$app\README.md" "$tmp\README.md" -Force }

  Remove-Item $app -Recurse -Force
  Rename-Item $tmp "diary-app9"
} else {
  Write-Host "diary-app9 sudah berisi project Expo, lewati create-expo-app."
}

Push-Location $app
npm install @reduxjs/toolkit react-redux
Pop-Location

# ---------- 4. .env mobile ----------
Step "4/4 Menentukan alamat API (.env mobile)"
$ip = $null
try {
  $ip = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
      $_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1" -and
      $_.InterfaceAlias -notmatch "vEthernet|VirtualBox|VMware|Loopback|Bluetooth"
    } | Select-Object -First 1).IPAddress
} catch {}
if (-not $ip) { $ip = "192.168.1.10"; Write-Host "IP tidak terdeteksi, pakai contoh $ip - EDIT manual!" -ForegroundColor Yellow }

$envText = "EXPO_PUBLIC_API_URL=http://${ip}:3000`n"
[IO.File]::WriteAllText("$app\.env", $envText, (New-Object Text.UTF8Encoding($false)))
Write-Host "Ditulis $app\.env -> http://${ip}:3000" -ForegroundColor Green

Write-Host @"

SELESAI. Langkah berikutnya:

  Terminal 1 (backend):  cd diary-api ; npm run dev
  Uji backend:           .\diary-api\scripts\test-api.ps1      (atau Postman: folder postman/)
  Terminal 2 (mobile):   cd diary-app9 ; npx expo start -c

Jika HP gagal konek (Network request failed), buka PowerShell sebagai Administrator:
  New-NetFirewallRule -DisplayName "Diary API 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow
"@ -ForegroundColor Cyan