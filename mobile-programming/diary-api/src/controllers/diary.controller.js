import { db } from "../config/database.js";

const MIN_TITLE = 3;
const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

function parseId(raw) {
  const id = Number(raw);
  return Number.isInteger(id) && id > 0 ? id : null;
}

function toBit(value) {
  return value === true || value === 1 || value === "1" || value === "true"
    ? 1
    : 0;
}

function validateTitle(title) {
  if (typeof title !== "string" || title.trim().length < MIN_TITLE) {
    return `title minimal ${MIN_TITLE} karakter`;
  }
  return null;
}

/* READ semua + TUGAS: pencarian ?search=kata */
export async function getAllDiaries(req, res) {
  try {
    const search = String(req.query.search ?? "").trim();

    let sql = "SELECT * FROM diaries";
    const params = [];

    if (search) {
      sql += " WHERE title LIKE ? OR body LIKE ? OR preview LIKE ?";
      const keyword = `%${search}%`;
      params.push(keyword, keyword, keyword);
    }

    sql += " ORDER BY created_at DESC, id DESC";

    const [rows] = await db.execute(sql, params);
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal mengambil data diary" });
  }
}

/* READ satu */
export async function getDiaryById(req, res) {
  try {
    const id = parseId(req.params.id);
    if (!id) {
      return res.status(400).json({ message: "ID diary tidak valid" });
    }

    const [rows] = await db.execute("SELECT * FROM diaries WHERE id = ?", [id]);

    if (rows.length === 0) {
      return res.status(404).json({ message: "Diary tidak ditemukan" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal mengambil detail diary" });
  }
}

/* CREATE */
export async function createDiary(req, res) {
  try {
    const { title, diary_date, body, mood = "😊" } = req.body ?? {};

    if (!title || !diary_date || !body) {
      return res.status(400).json({
        message: "title, diary_date, dan body wajib diisi",
      });
    }

    const titleError = validateTitle(title);
    if (titleError) {
      return res.status(400).json({ message: titleError });
    }

    if (typeof body !== "string" || !body.trim()) {
      return res.status(400).json({ message: "body wajib diisi" });
    }

    if (!DATE_RE.test(diary_date)) {
      return res
        .status(400)
        .json({ message: "diary_date harus berformat YYYY-MM-DD" });
    }

    if (typeof mood !== "string" || mood.length > 20) {
      return res.status(400).json({ message: "mood maksimal 20 karakter" });
    }

    const preview = body.trim().slice(0, 100);

    const [result] = await db.execute(
      `INSERT INTO diaries
         (title, diary_date, preview, body, mood)
       VALUES (?, ?, ?, ?, ?)`,
      [title.trim(), diary_date, preview, body.trim(), mood]
    );

    const [rows] = await db.execute("SELECT * FROM diaries WHERE id = ?", [
      result.insertId,
    ]);

    res.status(201).json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal menambahkan diary" });
  }
}

/* UPDATE (juga dipakai untuk Favorite: kirim { liked: true/false }) */
export async function updateDiary(req, res) {
  try {
    const id = parseId(req.params.id);
    if (!id) {
      return res.status(400).json({ message: "ID diary tidak valid" });
    }

    const [oldRows] = await db.execute("SELECT * FROM diaries WHERE id = ?", [
      id,
    ]);

    if (oldRows.length === 0) {
      return res.status(404).json({ message: "Diary tidak ditemukan" });
    }

    const old = oldRows[0];
    const input = req.body ?? {};

    const title = input.title ?? old.title;
    const diary_date = input.diary_date ?? old.diary_date;
    const body = input.body ?? old.body;
    const mood = input.mood ?? old.mood;
    const liked = input.liked !== undefined ? toBit(input.liked) : old.liked;

    const titleError = validateTitle(title);
    if (titleError) {
      return res.status(400).json({ message: titleError });
    }

    if (typeof body !== "string" || !body.trim()) {
      return res.status(400).json({ message: "body tidak boleh kosong" });
    }

    if (!DATE_RE.test(diary_date)) {
      return res
        .status(400)
        .json({ message: "diary_date harus berformat YYYY-MM-DD" });
    }

    if (typeof mood !== "string" || mood.length > 20) {
      return res.status(400).json({ message: "mood maksimal 20 karakter" });
    }

    const preview = body.trim().slice(0, 100);

    await db.execute(
      `UPDATE diaries
          SET title = ?,
              diary_date = ?,
              preview = ?,
              body = ?,
              mood = ?,
              liked = ?
        WHERE id = ?`,
      [title.trim(), diary_date, preview, body.trim(), mood, liked, id]
    );

    const [rows] = await db.execute("SELECT * FROM diaries WHERE id = ?", [id]);
    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal memperbarui diary" });
  }
}

/* DELETE */
export async function deleteDiary(req, res) {
  try {
    const id = parseId(req.params.id);
    if (!id) {
      return res.status(400).json({ message: "ID diary tidak valid" });
    }

    const [result] = await db.execute("DELETE FROM diaries WHERE id = ?", [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Diary tidak ditemukan" });
    }

    res.json({ message: "Diary berhasil dihapus" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal menghapus diary" });
  }
}