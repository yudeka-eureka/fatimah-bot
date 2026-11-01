---
name: upload-dokumen-gdrive
description: Use when uploading finished documents to Google Drive.
---

# Upload Dokumen ke Google Drive (Dr. Fatimah)

Dipanggil SETELAH dokumen selesai disusun dan lolos audit mutu Lapis 1. Tujuannya: arsip terpusat + tautan distribusi ke guru/Kepala Sekolah.

## Prasyarat
- Google Workspace sudah terhubung (token di `/opt/data/google_token.json`, auto-refresh).
- Semua perintah GAPI harus lewat environment Hermes — `python`/`python3` biasa TIDAK punya modul `google`/`pm`.

## Shorthand (wajib)
```bash
GAPI="/opt/hermes/scripts/run-in-hermes-env python3 /opt/data/skills/productivity/google-workspace/scripts/google_api.py"
```

## Struktur folder (sudah dibuat)
- Root: `Fatimah Bot - Dokumen` → id `1bRM5qS8BjDiKtvQ8Lvrp7pwUMNmtjN1j`
  - `Kurikulum & Modul Ajar` → id `1syz8pqJRrrlERhuLaNfEMQpyBK4_3tP8`
  - (buat subfolder lain sesuai jenis bila belum ada: `Surat Dinas`, `Notula Rapat`, `Poster & Humas`)

## Alur
1. Tentukan folder tujuan (cari dulu, buat kalau belum ada).
2. Upload file.
3. Verifikasi dengan membaca balik metadata (JANGAN klaim sukses tanpa `drive get`).
4. Kirim `webViewLink` ke user sebagai bukti.

## Perintah terverifikasi
```bash
# cari folder/file
$GAPI drive search "Fatimah Bot - Dokumen" --max 5

# buat subfolder di dalam root
$GAPI drive create-folder "Surat Dinas" --parent 1bRM5qS8BjDiKtvQ8Lvrp7pwUMNmtjN1j

# upload (auto-detect MIME; --name untuk nama rapi; --parent untuk subfolder)
$GAPI drive upload /path/file.docx --name "Nama Dokumen.docx" --parent FOLDER_ID

# verifikasi keberadaan + ambil link
$GAPI drive get FILE_ID
```

## Aturan
- Jangan upload ulang file yang sama — `drive search` nama file dulu; bila sudah ada, tanya user (timpa atau versi baru).
- Kembalikan `webViewLink` (bukan sekadar file ID) ke user.
- Simpan FILE_ID + link di ringkasan agar bisa dirujuk nanti.

## Pitfall
- Output GAPI selalu JSON; ambil field `id` dan `webViewLink`.
- Nama file: pakai spasi biasa aman, tapi hindari karakter `&` di SHELL (quote argumen) — nama dengan `&` seperti `Kurikulum & Modul Ajar` harus di-quote.
- Upload `.docx` otomatis jadi Google Doc (bisa diedit online); kalau mau file mentah utuh, pertimbangkan `.pdf`.
