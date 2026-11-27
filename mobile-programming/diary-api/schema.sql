-- Modul Praktikum 9 - Diary App
-- Jalankan sekali. Menjalankan ulang INSERT data awal akan menambah data duplikat.

CREATE DATABASE IF NOT EXISTS diary_app
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE diary_app;

CREATE TABLE IF NOT EXISTS diaries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  diary_date DATE NOT NULL,
  preview VARCHAR(255),
  body TEXT NOT NULL,
  mood VARCHAR(20) DEFAULT '😊',
  liked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO diaries
  (title, diary_date, preview, body, mood, liked)
VALUES
(
  'Pagi yang Tenang',
  '2026-11-23',
  'Jalan pagi sebelum memulai aktivitas.',
  'Pagi ini terasa tenang. Saya berjalan selama 20 menit.',
  '😌',
  false
),
(
  'Produktif di Kampus',
  '2026-11-22',
  'Menyelesaikan modul dan berdiskusi dengan tim.',
  'Hari ini cukup produktif karena beberapa target selesai.',
  '😄',
  true
);