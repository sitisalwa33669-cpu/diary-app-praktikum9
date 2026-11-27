# Diary App - CRUD React Native + REST API (Node.js, Express.js, MySQL)

Modul Praktikum 9 - Mobile Programming
Universitas Muhammadiyah Sukabumi, Fakultas Sains dan Teknologi, Teknik Informatika

| | |
|---|---|
| Nama / NIM | (isi nama dan NIM) |
| Kelas | (isi kelas) |

## Deskripsi
Aplikasi buku harian (Diary) berbasis React Native yang menyimpan data ke database MySQL melalui REST API.
Alur data: **React Native + Redux Toolkit -> Fetch API -> Express.js -> MySQL**.

## Teknologi
| Bagian | Teknologi |
|--------|-----------|
| Mobile | React Native, Expo, Expo Router |
| State management | Redux Toolkit, React-Redux |
| Backend | Node.js, Express.js, mysql2/promise |
| Database | MySQL |
| Pengujian API | Postman |

## Struktur Repository
```
mobile-programming/
├── diary-api/     Backend REST API (Express + MySQL)
├── diary-app9/    Source aplikasi React Native (Expo Router)
├── postman/       Collection dan environment Postman
├── docs/          Laporan praktikum dan screenshot
└── setup.ps1      Setup otomatis
```

## Fitur
- Create, Read, Update, Delete diary yang tersimpan di MySQL
- Favorite (nilai `liked` tersimpan di database) dan layar Favorites
- Pencarian diary: `GET /api/diaries?search=kata`
- Validasi judul minimal 3 karakter (frontend dan backend)
- Loading, error, empty state, dan pull to refresh
- State saving/deleting agar tombol tidak bisa ditekan berulang
- Konfirmasi saat meninggalkan form Edit yang belum disimpan
- Tampilan `created_at` pada halaman Detail

## Endpoint REST API
| CRUD | Method | Endpoint | SQL |
|------|--------|----------|-----|
| Create | POST | `/api/diaries` | INSERT |
| Read | GET | `/api/diaries`, `/api/diaries/:id` | SELECT |
| Update | PUT | `/api/diaries/:id` | UPDATE |
| Delete | DELETE | `/api/diaries/:id` | DELETE |

## Cara Menjalankan
Prasyarat: Node.js LTS, MySQL (XAMPP atau MySQL Server), Postman, Expo Go.

```powershell
cd mobile-programming
Set-ExecutionPolicy -Scope Process Bypass -Force
.\setup.ps1
```

Backend (terminal 1):
```powershell
cd diary-api
npm run dev
```

Aplikasi mobile (terminal 2):
```powershell
cd diary-app9
npx expo start -c
```

Catatan: HP dan laptop harus berada di Wi-Fi yang sama. Alamat API diatur di `diary-app9/.env` (`EXPO_PUBLIC_API_URL=http://IP-LAPTOP:3000`).

## Dokumentasi
- Laporan praktikum: [mobile-programming/docs/LAPORAN_PRAKTIKUM.md](mobile-programming/docs/LAPORAN_PRAKTIKUM.md)
- Panduan detail: [mobile-programming/README.md](mobile-programming/README.md)
- Collection Postman: folder [mobile-programming/postman](mobile-programming/postman)
