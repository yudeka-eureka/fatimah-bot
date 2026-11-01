---
name: cari-jurnal-ilmiah
description: "Use when the user asks to find & attach journal PDFs."
version: 1.0.0
author: Dr. Fatimah (pamong-utama)
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [jurnal, literatur, pendidikan, PDF, Sinta, OJS, research, Indonesia]
    related_skills: [arxiv, grounded-citations]
---

# Mencari & Mengunduh Jurnal Ilmiah (PDF)

Mencari artikel jurnal akademik lalu melampirkan PDF-nya ke pengguna. Kasus dominan untuk persona ini: jurnal pendidikan Indonesia (SD/MI, PGSD) yang diminta guru/dosen — mis. "cari jurnal cara mendidik anak SD di era AI".

## When to Use

Gunakan saat pengguna minta dicarikan/lampirkan artikel jurnal akademik (PDF), terutama topik pendidikan Indonesia; bukan untuk mencari paper arXiv CS/STEM (gunakan skill `arxiv` untuk itu).

## Alur

1. **Pilih sumber yang tepat — jangan otomatis ke arXiv.** arXiv kuat untuk CS/STEM, tapi lemah untuk pendidikan/ilmu sosial, apalagi topik berbahasa Indonesia. Untuk topik pendidikan Indonesia, mulai dari `web_search` (Google) yang langsung memunculkan halaman jurnal OJS beserta abstraknya.
2. **Kenali pola URL unduhan PDF.** Situs jurnal OJS (`ejurnal.*.ac.id`, `journal.unpas.ac.id`, `jurnal.uns.ac.id`, `jurnal.unimed.ac.id`, dsb.) memakai pola `…/article/download/{id}/{galley}/{file}` atau `…/article/viewFile/{id}/{file}`. Hasil `web_search` biasanya sudah memuat URL `article/download` langsung — pilih kandidat yang (a) relevan topik, (b) Sinta terakreditasi, (c) ber-URL unduhan langsung. Kumpulkan 5–10 kandidat.
3. **Unduh dengan curl + User-Agent browser** — banyak situs OJS menolak `curl` tanpa UA:
   `curl -sL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) … Chrome/124.0 Safari/537.36" -o file.pdf "URL"`.
   Jalankan berurutan, bukan dengan `&` (terminal tool menolak backgrounding di perintah foreground).
4. **Verifikasi tiap file benar-benar PDF** — `head -c 8 file.pdf | grep -q '%PDF'`; ukuran puluhan–ratusan KB jadi sinyal pendukung.
5. **Konfirmasi isi/judul, bukan cuma header** — `read_file` pada PDF mengekstrak lapisan teksnya otomatis; baca halaman pertama untuk memastikan judul/abstrak cocok artikel yang dimaksud, bukan halaman 404/error yang tersimpan sebagai `.pdf`.
6. **Lampirkan via `MEDIA:`** — kirim tiap berkas sebagai baris `MEDIA:/absolute/path/file.pdf` di respons Telegram, lengkapi dengan daftar judul + penulis + nama jurnal + volume/nomor.
7. **Arsipkan ke Google Drive (WAJIB)** — aturan tetap user: SEMUA berkas yang dibuat/diunduh harus tersimpan di Google Drive. Buat/ambil subfolder `Jurnal Ilmiah` (id `1nFCD0EWOMYyEDyLetq-L8entC57wNdEz`) di dalam root `Fatimah Bot - Dokumen`, upload tiap PDF (`drive upload … --parent`), verifikasi dengan `drive get`, lalu kembalikan `webViewLink`-nya. Lihat skill `upload-dokumen-gdrive`.

## Pitfalls

- **Jangan andalkan arXiv untuk topik pendidikan Indonesia** — hasilnya melenceng (paper CS/AI umum, bukan jenjang SD/MI). Gunakan `web_search` dan unduh langsung dari situs jurnal OJS/Sinta/Garuda.
- **Header `%PDF` bukan bukti isi benar** — halaman 404/error bisa tersimpan sebagai PDF; selalu baca halaman pertama untuk konfirmasi judul/abstrak.
- **Jangan bergantung pada CLI PDF eksternal** (`pdftotext`, `pdfinfo`) yang mungkin tak terpasang — verifikasi teks lewat `read_file` pada PDF.
- **Semantic Scholar cepat rate-limit (429) tanpa API key** — jangan jadikan satu-satunya sumber; `web_search` + unduhan OJS langsung lebih andal untuk jurnal Indonesia.
- **Tampilan token/URL panjang bisa terlihat terpotong** oleh lapisan display — sebelum menyimpulkan isi rusak, cek panjang & repr secara programatik (lihat juga pitfall "Extracting a full confirmation / verification link" di skill `google-workspace`).
