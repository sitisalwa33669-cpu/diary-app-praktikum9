# Modul Praktikum 9 - CRUD React Native + REST API + Node.js + MySQL
Studi kasus: **Diary App** (Expo Router, Redux Toolkit, Postman) - Universitas Muhammadiyah Sukabumi.

```
mobile-programming/
├── diary-api/      Backend Express + MySQL (modul G - O)
├── diary-app9/     Source React Native (overlay untuk template tabs Expo, modul T - AG)
├── postman/        Collection + Environment "Diary App API"
├── docs/           Laporan, jawaban diskusi, skenario uji kelas, folder screenshots
└── setup.ps1       Setup otomatis semuanya
```

## Cara cepat (PowerShell)
```powershell
cd mobile-programming
Set-ExecutionPolicy -Scope Process Bypass -Force
.\setup.ps1
```
Lalu:
```powershell
cd diary-api;  npm run dev                 # terminal 1
.\diary-api\scripts\test-api.ps1           # gate backend (opsional selain Postman)
cd diary-app9; npx expo start -c           # terminal 2
```

## Tugas praktikum yang sudah dikerjakan
| # | Tugas | Lokasi |
|---|-------|--------|
| 1 | Favorite via PUT (`liked` tersimpan di MySQL) | `diarySlice.ts` (`toggleLike`), `DiaryCard.tsx`, `detail/[id].tsx`, backend `updateDiary` |
| 2 | Favorites Screen (liked = true) | `app/(tabs)/favorites.tsx` |
| 3 | Validasi title min 3 karakter (frontend + backend) | `src/utils/validation.ts`, `diary.controller.js` |
| 4 | Pencarian `GET /api/diaries?search=kata` | `diary.controller.js`, kolom cari di `app/(tabs)/index.tsx` |
| 5 | State `saving` / `deleting` (tombol nonaktif saat request) | `diarySlice.ts`, create / edit / detail |
| 6 | Konfirmasi keluar dari form Edit | `app/edit/[id].tsx` (`beforeRemove`) |
| 7 | `created_at` di Detail | `app/detail/[id].tsx` |
| 8 | Bukti Postman GET/POST/PUT/DELETE | `postman/` + taruh screenshot di `docs/screenshots/` |
| 9 | Dokumentasi kasus error jaringan | `docs/LAPORAN_PRAKTIKUM.md` bagian 4 |

## Catatan teknis (perbaikan kecil dari modul)
- `charset: "utf8mb4"` ditambahkan pada pool MySQL agar emoji mood tersimpan benar.
- Urutan list `ORDER BY created_at DESC, id DESC` agar stabil untuk data yang dibuat bersamaan.
- Home & Favorites memanggil ulang API saat layar fokus, sehingga hasil pencarian di Home tidak membuat Favorites kosong.
- Android Emulator: ganti IP di `diary-app9/.env` menjadi `http://10.0.2.2:3000`.