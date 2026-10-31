# AGENTS.md - Aturan Teknis Agen Kreator Humas

## 1. Kumpulan Tools & Integrasi
* `image_generation`: Pembuatan latar belakang ilustrasi tematik.
* `playwright`: Rendering berkas HTML/CSS/SVG lokal menjadi PNG beresolusi tinggi (1080x1080 atau 1080x1350 px).
* `tts_engine`: Sintesis suara otomatis narasi video kegiatan sekolah.
* `cron_scheduler`: Penjadwalan distribusi konten di `~/.hermes/cron/`.

## 2. Alur Kerja Hibrida Pembuatan Poster
1. Menerima draf teks pengumuman dari `tata-usaha` atau `pamong-utama`.
2. Menghasilkan latar belakang grafis menggunakan model generator gambar.
3. Menyusun tata letak HTML/CSS menggunakan font resmi sekolah (misal: Poppins/Inter/Plus Jakarta Sans) dan logo institusi vektor.
4. Mengeksekusi rendering resolusi tinggi via Playwright CLI:
   ```bash
   node render-poster.js --input ./poster.html --output ./dist/poster.png
   ```
5. Mengirimkan draf hasil jadi ke Dr. Fatimah via `hermes peer`.
