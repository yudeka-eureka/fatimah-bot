---
name: canva-design
description: "Use when generating/editing designs via Canva MCP."
version: 1.0.0
author: Dr. Fatimah (pamong-utama)
license: MIT
metadata:
  hermes:
    tags: [canva, desain, poster, flyer, webinar, mcp, gambar]
    related_skills: [poster-pendidikan, upload-dokumen-gdrive]
---

# Desain via Canva MCP

Membuat/mengedit desain visual (poster, flyer, presentasi, webinar) lewat Canva MCP (`connectors__canva_mcp__*`). Ini jalur UTAMA untuk desain — Bapak meminta jangan "ngoding sendiri" (HTML/CSS) untuk desain; pakai Canva MCP.

## When to Use

Gunakan saat pengguna minta membuat desain/poster/flyer/dokumen visual. Bukan untuk ilustrasi via kode; pakai Canva MCP kecuali pengguna secara eksplisit minta jalur lain.

## Alur Kerja (urutan wajib)

1. **Generate** — `GENERATE_DESIGN` dengan `query` (deskripsi detail, termasuk teks Indonesia yang harus dieja benar) + `design_type` (poster/flyer/...). Hasilnya 4 kandidat (`candidate_id` + `job_id`).
2. **Jadikan desain** — `CREATE_DESIGN_FROM_CANDIDATE` (per kandidat yang dipilih) → dapat `design_id` + `edit_url`.
3. **Kirim PREVIEW dulu (default)** — `GET_DESIGN` (design_id) → `thumbnail.url` → unduh `fallback` S3 (`document-export.canva.com/...`) → kirim PNG preview + `edit_url` ke user. Ekspor sering gagal untuk desain AI baru (lihat Pitfalls).
4. **Ekspor (bila perlu)** — setelah desain dibuka/disimpan di editor Canva, `GET_EXPORT_FORMATS` dulu, lalu `EXPORT_DESIGN` dengan `format.type` (png/jpg/pdf) + `width` (mis. 1600).
5. **Unduh & kirim** — `curl -sL -A <UA-browser>` ke URL itu, verifikasi `%PDF`/PNG magic, lalu kirim via `MEDIA:`.
6. **Arsipkan** — upload PNG ke Google Drive (lihat skill `upload-dokumen-gdrive`).

## Pitfalls

- **Thumbnail Canva tidak bisa ditampilkan.** URL `design.canva.ai/...` dan `canva.com/d/...` dilindungi Cloudflare ("Client Challenge") — mengembalikan HTML, bukan gambar. Jangan hotlink.
- **`EXPORT_DESIGN` sering ditolak ("Not allowed to access design")** untuk desain AI yang baru dibuat (`design_type` masih "unknown", tanda `disableexport=T` di thumbnail). Jangan ulangi ekspor berkali-kali; ambil PREVIEW via `GET_DESIGN` → `thumbnail.url` → unduh `fallback` S3 lalu kirim PNG preview + `edit_url`. Ekspor baru berhasil setelah desain dibuka/disimpan sekali di editor Canva.
- **Login Canva user:** minta login pakai akun `fatimah.62.education@gmail.com`; Canva kirim kode verifikasi ke Gmail — baca lewat `google_api.py` (gmail) lalu sampaikan kodenya ke user.
- **Unggah aset hanya dari URL publik.** `UPLOAD_ASSET_FROM_URL` hanya menerima URL yang SUDAH publik. File lokal/private JANGAN di-host ke layanan publik demi membuat URL — minta URL publik dari pengguna, atau deskripsikan asetnya di `query`.
- **`tool_call` butuh field `name`.** Setiap item di `tool_call` wajib berisi `name` (nama tool, mis. `connectors__canva_mcp__GENERATE_DESIGN`) + `arguments`. Lupa `name` → error "requires a 'name'".
- **Ekspor tanpa `GET_EXPORT_FORMATS` berisiko gagal** pada format yang tak didukung; cek dulu.
- **Logo ber-latar putih** tampil sebagai kotak putih di poster; buat transparan dulu (flood-fill dari tepi via PIL) bila perlu.
- **Canva MCP = hosted connector**, bukan local MCP: hubungkan lewat `manage_connections` action=`connect` (bukan `install`), lalu user otorisasi lewat URL portal. Cek `status` setelah user bilang selesai.
