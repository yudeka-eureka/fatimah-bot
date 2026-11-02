# Canva MCP — Membuat & Menampilkan Desain

Membuat desain (poster/flyer/presentasi/dokumen) lewat Canva MCP dan menampilkannya sebagai gambar ke pengguna Telegram.

## Koneksi (sekali)
- `canva_mcp` adalah **hosted connector**, bukan MCP lokal. Sambungkan dengan `manage_connections action=connect connectors=["canva_mcp"]` — `install` dengan `mcp:true` ditolak ("hosted connector account").
- OAuth lewat Nous Portal (Dynamic Client Registration): **client ID/secret pengguna TIDAK diperlukan**. Config `mcp-remote` + `api.canva.com/connect/v1/mcp` (jalur lama) tak perlu dipakai; bawaan Hermes memakai `mcp.canva.com/mcp`.
- Setelah pengguna menyetujui `connect_url` di browser, cek `action=status` → `connected:true`. Tool tersedia dengan nama `connectors__canva_mcp__*` (panggil lewat `tool_call`, lalu baca skema dengan `tool_describe`).

## Alur membuat desain
1. `GENERATE_DESIGN` (`query` rinci + `design_type`). Hasil: `job_id` + `generated_designs[]` (masing-masing `candidate_id` + `thumbnail` + `url`).
2. `CREATE_DESIGN_FROM_CANDIDATE` (`job_id` + `candidate_id`) → `design_summary.id` (design_id, awalan "D", 11 karakter) + `urls.edit_url` + `view_url`.
3. Menampilkan ke pengguna: ekspor & unduh PNG (bawah), kirim via `MEDIA:`.

## Menampilkan desain sebagai gambar (WAJIB ekspor)
- **Thumbnail `design.canva.ai/*` TIDAK bisa di-hotlink** — mengembalikan halaman "Client Challenge" Cloudflare (HTML), bukan gambar. Jangan kirim `![alt](thumbnail_url)`.
- `GET_EXPORT_FORMATS` (design_id) dulu — jangan menebak format; poster/flyer mendukung png/jpg/pdf.
- `EXPORT_DESIGN` (design_id + `format:{type:"png", width:1600}`) → `job.urls[]` = URL S3 bertanda tangan (berlaku ~7 jam). Unduh dengan `curl -L -A "Mozilla/5.0..."`, verifikasi magic PNG (`89504e47...`), kirim `MEDIA:`.

## Pitfall
- Poster hasil `GENERATE_DESIGN` bisa keluar **portrait** walau query minta landscape — sebutkan orientasi aktual saat menyajikan, tawarkan regenerasi.
- `GENERATE_DESIGN` tidak membawa konteks percakapan sebelumnya — ulangi semua detail (gaya, teks, warna) di `query` tiap iterasi.
- Tiap desain yang dibuat jadi tersimpan di akun Canva pengguna — jangan buat semua kandidat tanpa konfirmasi bila ragu; buat satu dulu, tawarkan kandidat lain.