import "dotenv/config";
import express from "express";
import cors from "cors";
import diaryRoutes from "./routes/diary.routes.js";
import { db } from "./config/database.js";

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "Diary API aktif" });
});

app.get("/health", async (req, res) => {
  try {
    await db.query("SELECT 1");
    res.json({ status: "ok", database: "connected" });
  } catch (error) {
    res.status(500).json({ status: "error", database: "disconnected" });
  }
});

app.use("/api/diaries", diaryRoutes);

// route tidak dikenal -> JSON 404
app.use((req, res) => {
  res.status(404).json({ message: `Route ${req.method} ${req.path} tidak ditemukan` });
});

// JSON body rusak -> 400 (bukan 500)
app.use((err, req, res, next) => {
  if (err.type === "entity.parse.failed") {
    return res.status(400).json({ message: "Body JSON tidak valid" });
  }
  console.error(err);
  res.status(500).json({ message: "Terjadi kesalahan pada server" });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Diary API berjalan pada port ${PORT}`);
});