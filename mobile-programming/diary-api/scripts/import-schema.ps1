# Import schema.sql ke MySQL (XAMPP / MySQL Server)
# Contoh: .\scripts\import-schema.ps1
#         .\scripts\import-schema.ps1 -User root -Password rahasia
param(
  [string]$User = "root",
  [string]$Password = "",
  [string]$MysqlPath = ""
)

$schema = Join-Path $PSScriptRoot "..\schema.sql" | Resolve-Path

if (-not $MysqlPath) {
  $cmd = Get-Command mysql.exe -ErrorAction SilentlyContinue
  if ($cmd) { $MysqlPath = $cmd.Source }
  else {
    $candidates = @(
      "C:\xampp\mysql\bin\mysql.exe",
      "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
      "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
    )
    $MysqlPath = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
  }
}

if (-not $MysqlPath) {
  Write-Host "mysql.exe tidak ditemukan. Jalankan dengan -MysqlPath 'C:\...\mysql.exe' atau import schema.sql lewat Workbench/phpMyAdmin." -ForegroundColor Red
  exit 1
}

$pass = ""
if ($Password) { $pass = "-p$Password" }

Write-Host "Import $schema memakai $MysqlPath ..." -ForegroundColor Cyan
cmd /c "`"$MysqlPath`" -u $User $pass --default-character-set=utf8mb4 < `"$schema`""

if ($LASTEXITCODE -eq 0) { Write-Host "Database diary_app siap." -ForegroundColor Green }
else { Write-Host "Import gagal (kode $LASTEXITCODE). Cek user/password dan pastikan MySQL aktif." -ForegroundColor Red }