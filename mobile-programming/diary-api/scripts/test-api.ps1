# Uji otomatis CRUD (eksperimen di kelas) - alternatif cepat selain Postman
# Pastikan: MySQL aktif + `npm run dev` berjalan.
param([string]$BaseUrl = "http://localhost:3000")

$script:pass = 0
$script:fail = 0

function Call($method, $path, $body = $null) {
  $params = @{ Uri = "$BaseUrl$path"; Method = $method; UseBasicParsing = $true }
  if ($null -ne $body) {
    $params.Body = [Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json -Depth 5))
    $params.ContentType = "application/json; charset=utf-8"
  }
  try {
    $r = Invoke-WebRequest @params
    return @{ Status = [int]$r.StatusCode; Json = ($r.Content | ConvertFrom-Json) }
  } catch {
    $status = 0
    if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode }
    $json = $null
    if ($_.ErrorDetails.Message) { try { $json = $_.ErrorDetails.Message | ConvertFrom-Json } catch {} }
    return @{ Status = $status; Json = $json }
  }
}

function Check($name, $ok) {
  if ($ok) { Write-Host "  [PASS] $name" -ForegroundColor Green; $script:pass++ }
  else     { Write-Host "  [FAIL] $name" -ForegroundColor Red;   $script:fail++ }
}

Write-Host "`n== Gate backend ($BaseUrl) ==" -ForegroundColor Cyan

$r = Call GET "/health"
Check "GET /health -> 200 & connected" ($r.Status -eq 200 -and $r.Json.database -eq "connected")

$r = Call GET "/api/diaries"
Check "GET /api/diaries -> 200" ($r.Status -eq 200)

$new = @{ title = "Belajar REST API"; diary_date = "2026-11-24"; body = "Hari ini saya belajar menghubungkan Express dan MySQL."; mood = "😄" }
$r = Call POST "/api/diaries" $new
Check "POST -> 201 & id baru" ($r.Status -eq 201 -and $r.Json.id -gt 0)
$id = $r.Json.id

$r = Call GET "/api/diaries/$id"
Check "GET /:id -> 200 & judul sesuai" ($r.Status -eq 200 -and $r.Json.title -eq "Belajar REST API")

$r = Call PUT "/api/diaries/$id" @{ title = "Belajar CRUD dan REST API"; body = "Saya memahami alur CRUD pada aplikasi mobile." }
Check "PUT -> 200 & data berubah" ($r.Status -eq 200 -and $r.Json.title -eq "Belajar CRUD dan REST API")

$r = Call PUT "/api/diaries/$id" @{ liked = $true }
Check "PUT liked=true -> liked tersimpan (Favorite)" ($r.Status -eq 200 -and [int]$r.Json.liked -eq 1)

$r = Call GET "/api/diaries?search=CRUD"
Check "GET ?search=CRUD -> menemukan data" ($r.Status -eq 200 -and @($r.Json).Count -ge 1)

$r = Call GET "/api/diaries?search=zzzxxyy-tidak-ada"
Check "GET ?search=<tidak ada> -> array kosong" ($r.Status -eq 200 -and @($r.Json).Count -eq 0)

Write-Host "`n== Kasus error ==" -ForegroundColor Cyan

$r = Call POST "/api/diaries" @{ title = "ab"; diary_date = "2026-11-24"; body = "isi" }
Check "POST title 2 karakter -> 400" ($r.Status -eq 400)

$r = Call POST "/api/diaries" @{ title = "Tanpa body"; diary_date = "2026-11-24" }
Check "POST tanpa body -> 400" ($r.Status -eq 400)

$r = Call PUT "/api/diaries/$id" @{ title = "x" }
Check "PUT title 1 karakter -> 400" ($r.Status -eq 400)

$r = Call GET "/api/diaries/999999"
Check "GET id tidak ada -> 404" ($r.Status -eq 404)

$r = Call DELETE "/api/diaries/$id"
Check "DELETE -> 200" ($r.Status -eq 200)

$r = Call DELETE "/api/diaries/$id"
Check "DELETE ulang -> 404" ($r.Status -eq 404)

Write-Host "`nHasil: $script:pass lulus, $script:fail gagal." -ForegroundColor Cyan
if ($script:fail -eq 0) { Write-Host "Gate backend LULUS - lanjut ke React Native." -ForegroundColor Green }
else { Write-Host "Perbaiki backend dulu sebelum masuk mobile app." -ForegroundColor Yellow }