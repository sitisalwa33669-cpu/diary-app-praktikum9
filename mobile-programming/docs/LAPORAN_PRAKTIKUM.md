# Laporan Praktikum 9 - CRUD React Native dengan REST API, Node.js, Express.js, dan MySQL

| | |
|---|---|
| Nama / NIM | ............................ |
| Kelas | ............................ |
| Tanggal | ............................ |
| Mata Kuliah | Mobile Programming - Pertemuan 9 |

## 1. Hasil Tugas Praktikum
| # | Tugas | Status | Implementasi |
|---|-------|:-----:|--------------|
| 1 | Favorite dengan PUT, `liked` tersimpan di MySQL | ✅ | thunk `toggleLike` -> `PUT /api/diaries/:id {liked}` -> kolom `liked` |
| 2 | Favorites Screen hanya `liked = true` | ✅ | `entries.filter(Number(liked) === 1)` |
| 3 | Validasi title >= 3 karakter (frontend & backend) | ✅ | `validateDiaryForm()` dan `validateTitle()` -> HTTP 400 |
| 4 | `GET /api/diaries?search=kata` | ✅ | `LIKE` pada title, body, preview (query berparameter `?`) |
| 5 | State saving / deleting | ✅ | `saving`, `deleting`, `likingIds` di Redux; tombol `disabled` |
| 6 | Konfirmasi keluar form Edit belum disimpan | ✅ | listener `beforeRemove` + `Alert` |
| 7 | `created_at` di Detail | ✅ | "Dibuat: ..." (+ "Diubah" bila berbeda) |
| 8 | Screenshot Postman GET/POST/PUT/DELETE | ⬜ | Isi bagian 3 |
| 9 | Dokumentasi 1 kasus error jaringan | ✅ | Bagian 4 |

## 2. Eksperimen di Kelas

### 2.1 Gate backend (modul S) - jalankan `.\diary-api\scripts\test-api.ps1`
| Pengujian | Expected | Hasil | Lulus |
|-----------|----------|-------|:----:|
| GET /health | 200, database connected | | ☐ |
| GET /api/diaries | 200, array | | ☐ |
| GET /api/diaries/:id | 200, satu object | | ☐ |
| POST valid | 201, row baru di MySQL | | ☐ |
| PUT valid | 200, row berubah | | ☐ |
| PUT `{liked:true}` | 200, `liked = 1` | | ☐ |
| GET ?search=kata | hanya data yang cocok | | ☐ |
| POST title < 3 karakter | 400 | | ☐ |
| POST tanpa body | 400 | | ☐ |
| GET id tidak ada | 404 | | ☐ |
| DELETE valid / ulang | 200 / 404 | | ☐ |

### 2.2 Skenario end-to-end mobile (modul AH.4)
| No | Aksi User | Expected UI | Expected MySQL | Lulus |
|----|-----------|-------------|----------------|:----:|
| 1 | Buka Home | Data diary tampil | SELECT mengembalikan data | ☐ |
| 2 | Pull to refresh | List refresh tanpa crash | Tidak mengubah row | ☐ |
| 3 | Tambah diary | Diary baru tampil di Home | Row INSERT bertambah | ☐ |
| 4 | Buka Detail | Isi sesuai pilihan + created_at | ID sesuai | ☐ |
| 5 | Edit diary | Detail menampilkan data terbaru | Row UPDATE berubah | ☐ |
| 6 | Hapus diary | Kembali ke Home, item hilang | Row hilang | ☐ |
| 7 | Restart app | Data tetap ada | Data berasal dari MySQL | ☐ |
| 8 | Tekan hati pada diary | Ikon berubah, muncul di tab Favorite | `liked = 1` | ☐ |
| 9 | Ketik kata di kolom cari | List terfilter, kosong -> pesan "Tidak ada diary..." | SELECT ... LIKE | ☐ |
| 10 | Simpan judul 2 karakter | Alert validasi, request tidak terkirim | Tidak ada perubahan | ☐ |
| 11 | Tekan Simpan dua kali cepat | Tombol nonaktif "Menyimpan..." | Hanya 1 row baru | ☐ |
| 12 | Ubah teks Edit lalu tekan Back | Dialog konfirmasi muncul | Tidak ada perubahan | ☐ |

### 2.3 Eksperimen tambahan (isi pengamatan)
1. **Matikan MySQL**, buka `/health` -> harapan: HTTP 500 `database: disconnected`. Pengamatan: ......
2. **Matikan backend**, tarik refresh di app -> harapan: pesan "Tidak dapat terhubung ke server...". Pengamatan: ......
3. **Ubah langsung row di MySQL**, pull-to-refresh -> data di app ikut berubah (Redux hanya cache). Pengamatan: ......
4. Kirim POST tanpa header `Content-Type: application/json` -> harapan: 400 karena body kosong. Pengamatan: ......

## 3. Bukti Postman
Import `postman/Diary App API.postman_collection.json` dan `postman/Diary App API.postman_environment.json`, pilih environment **Diary App API (local)**, lalu klik **Run collection** (semua test harus hijau). Simpan screenshot di `docs/screenshots/`:

| File | Isi |
|------|-----|
| `01-get-diaries.png` | GET /api/diaries - 200 |
| `02-post-diary.png` | POST - 201 |
| `03-put-diary.png` | PUT - 200 |
| `04-delete-diary.png` | DELETE - 200 |
| `05-runner-hasil.png` | Collection Runner semua test hijau |

## 4. Dokumentasi Kasus Error Jaringan
**Gejala:** Postman berhasil, tetapi di HP muncul layar error *"Tidak dapat terhubung ke server..."* (`TypeError: Network request failed`).

**Penyebab yang mungkin & cara diagnosis**
| Penyebab | Cara cek | Perbaikan |
|----------|----------|-----------|
| `EXPO_PUBLIC_API_URL` memakai `localhost` | Lihat `diary-app9/.env` | Ganti ke IPv4 laptop (`ipconfig`), mis. `http://192.168.1.10:3000` |
| HP dan laptop beda Wi-Fi | Cek SSID kedua perangkat | Hubungkan ke jaringan yang sama (hindari "client isolation" di Wi-Fi kampus; gunakan hotspot HP bila perlu) |
| Firewall Windows memblokir port 3000 | Buka `http://<IP-laptop>:3000/health` di browser HP; gagal = diblokir | PowerShell Administrator: `New-NetFirewallRule -DisplayName "Diary API 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow` |
| `.env` Expo tidak terbaca | Variabel `EXPO_PUBLIC_*` hanya dibaca saat bundler start | Jalankan `npx expo start -c` setelah mengubah `.env` |
| Emulator Android | `localhost` = emulator itu sendiri | Gunakan `http://10.0.2.2:3000` |

**Kasus yang saya alami:** ........................ (isi dengan kejadian nyata di kelas)
**Langkah perbaikan:** ........................
**Bukti:** screenshot `docs/screenshots/06-error-jaringan.png`

## 5. Jawaban Pertanyaan Diskusi
1. **Mengapa React Native tidak langsung ke MySQL?** Kredensial database akan tertanam di aplikasi yang bisa dibongkar siapa pun; driver MySQL (TCP) tidak cocok untuk runtime mobile; tidak ada lapisan validasi/otorisasi; port database terbuka ke internet. API menjadi satu-satunya pintu yang bisa divalidasi dan diamankan.
2. **Redux Store vs MySQL?** Redux Store adalah state di memori perangkat (cepat, sementara, hilang saat app ditutup) untuk mengatur UI. MySQL adalah penyimpanan permanen di server yang menjadi sumber kebenaran data.
3. **Mengapa uji di Postman dulu?** Memisahkan sumber error: jika endpoint sudah lulus di Postman, error di app pasti berasal dari client (URL, state, UI), bukan backend.
4. **POST vs PUT?** POST membuat resource baru (server menentukan id, tidak idempoten - kirim dua kali menghasilkan dua row). PUT mengubah resource yang sudah ada pada URL tertentu (idempoten - hasil sama bila diulang).
5. **Fungsi 201, 400, 404, 500?** 201: resource berhasil dibuat. 400: input klien tidak valid. 404: data/route tidak ditemukan. 500: kesalahan di server/database.
6. **Mengapa HP tidak bisa pakai `localhost` laptop?** `localhost` selalu menunjuk perangkat yang menjalankan kode; di HP berarti HP itu sendiri. Harus memakai IP laptop di jaringan yang sama.
7. **Fungsi `createAsyncThunk`?** Membungkus operasi async (fetch) dan otomatis mengirim action `pending`, `fulfilled`, `rejected` sehingga loading/error/data bisa ditangani di `extraReducers`.
8. **Keuntungan memisahkan api service?** Screen fokus ke UI, URL/header/penanganan error terpusat di satu tempat, mudah diuji dan diganti (mis. beralih ke Axios) tanpa mengubah screen.
9. **Mengapa placeholder `?`?** Nilai dikirim terpisah dari teks SQL sehingga input user tidak bisa mengubah struktur query (mencegah SQL injection).
10. **Alur tombol Hapus Diary:** tekan tombol -> `Alert` konfirmasi -> `dispatch(removeDiary(id))` -> pending (`deleting = true`, tombol nonaktif) -> `fetch DELETE /api/diaries/:id` -> Express route -> controller `DELETE FROM diaries WHERE id = ?` -> JSON `{message}` -> `fulfilled`: entry dihapus dari Redux -> UI re-render, `router.replace("/")`. Jika gagal: `rejected` -> Alert error.

## 6. Checklist Praktikum (modul AK)
- ☐ diary-api dibuat  ☐ library terpasang  ☐ database & tabel dibuat  ☐ backend terhubung MySQL
- ☐ GET/POST/PUT/DELETE lulus di Postman  ☐ collection tersimpan  ☐ diary-app9 dibuat  ☐ Redux terpasang
- ☐ `EXPO_PUBLIC_API_URL` benar  ☐ Home/Create/Edit/Delete berfungsi  ☐ loading/error/empty tampil  ☐ data tetap setelah restart