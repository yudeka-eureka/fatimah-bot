---
name: upload-dokumen-gdrive
description: Use when uploading created/downloaded files to Google Drive.
---

# Upload Dokumen ke Google Drive (Dr. Fatimah)

**ATURAN TETAP user:** setiap berkas yang dibuat/diunduh (jurnal, PDF, dokumen, dll.) WAJIB diarsipkan ke Google Drive dan tautannya (`webViewLink`) dilaporkan ke user — bukan hanya dokumen dinas yang lolos audit.

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
  - `Jurnal Ilmiah` → id `1nFCD0EWOMYyEDyLetq-L8entC57wNdEz`
  - `Poster & Humas` → id `1H1li_7k45HmDpN7jegqGCu5VQ1qult68`
  - (buat subfolder lain sesuai jenis bila belum ada: `Surat Dinas`, `Notula Rapat`)

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

## Mengonversi .docx menjadi Google Doc (bisa diedit)

`drive upload` menyimpan `.docx` sebagai file Word, bukan Google Doc. Untuk menghasilkan Google Doc asli yang bisa diedit online, unggah `.docx` lewat Drive API dengan `mimeType: application/vnd.google-apps.document` pada metadata (memicu konversi impor; tabel, heading, dan bullet ikut terkonversi). Jalankan lewat `run-in-hermes-env`:

```python
import sys
sys.path.insert(0, "/opt/data/skills/productivity/google-workspace/scripts")
from google_api import build_service
from googleapiclient.http import MediaFileUpload

service = build_service("drive", "v3")
media = MediaFileUpload("dok.docx",
    mimetype="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    resumable=True)
metadata = {"name": "Nama Dok", "mimeType": "application/vnd.google-apps.document",
            "parents": [FOLDER_ID]}
res = service.files().create(body=metadata, media_body=media,
    fields="id, name, mimeType, webViewLink").execute()
```

Verifikasi: `mimeType` hasil harus `application/vnd.google-apps.document` dan `webViewLink` berawal `https://docs.google.com/document/.../edit`. Buat `.docx`-nya pakai `python-docx` agar tabel & heading tersusun rapi sebelum dikonversi.

## Aturan
- Jangan upload ulang file yang sama — `drive search` nama file dulu; bila sudah ada, tanya user (timpa atau versi baru).
- Kembalikan `webViewLink` (bukan sekadar file ID) ke user.
- Simpan FILE_ID + link di ringkasan agar bisa dirujuk nanti.

## Pitfall
- Output GAPI selalu JSON; ambil field `id` dan `webViewLink`.
- Nama file: pakai spasi biasa aman, tapi hindari karakter `&` di SHELL (quote argumen) — nama dengan `&` seperti `Kurikulum & Modul Ajar` harus di-quote.
- `drive upload` `.docx` TIDAK otomatis jadi Google Doc — ia menyimpan file Word apa adanya. Bila perlu dokumen yang bisa diedit online, pakai konversi pada bagian di bawah.
