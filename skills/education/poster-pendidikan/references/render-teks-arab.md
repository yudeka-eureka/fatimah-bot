# Render Teks Arab (Ayat / Kaligrafi / Doa) → PNG

Untuk poster yang memuat teks Arab (ayat Al-Qur'an, bismillah, doa, nama masjid/madrasah), jalur HTML/CSS → Chromium headless adalah pilihan tepat karena:
- Ejaan teks suci dijamin persis — image-gen / Canva AI sering mengacaukan huruf Arab, padahal teks harus 100% akurat.
- Warna, layout, dan bingkai presisi + deterministik, tanpa API key.

## Langkah
1. **Unduh font Arab lokal** — container headless TIDAK punya font Arab bawaan (hanya DejaVu), sehingga Arab tampil tofu (□). Ambil woff2 dari Google Fonts CSS2 API dengan UA Chrome, lalu unduh subset yang tepat:
   - **Amiri** (400 + 700) untuk Arab — kaligrafi Naskh, ideal untuk ayat; pilih URL pada blok `/* arabic */`.
   - **Poppins** (400/500/600/700) untuk terjemahan Indonesia — pilih URL pada blok `/* latin */`.
2. **`@font-face` via `file://` absolut** (bukan `<link>`/`@import`) agar render deterministik tanpa bergantung jaringan saat screenshot.
3. **Kontainer Arab**: beri `direction: rtl; lang="ar"` dan `line-height` tinggi (~2.0) agar tashkeel/harakat tidak terpotong.
4. Render dengan `--window-size` dimensi persis (mis. `1080,1350` untuk portrait 4:5).
5. **Verifikasi PNG tanpa PIL** (PIL bisa absen di python3 biasa): `magic = data[:8] == b'\x89PNG\r\n\x1a\n'`; dimensi `struct.unpack('>II', data[16:24])`.

## Cara ambil woff2
```bash
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"
curl -s -A "$UA" "https://fonts.googleapis.com/css2?family=Amiri:wght@400;700&display=swap" -o amiri.css
grep -oE "https://[^)]+\.woff2" amiri.css   # pilih URL pada blok /* arabic */
curl -s -A "$UA" -o amiri-400.woff2 "<url_blok_arabic_400>"
```

## Palet & ornamen Islami (poster ayat)
- Palet: emerald tua (`#0b3a2c` / `#07261d`) + ivory (`#f5eed9`) + emas (`#d4af37`).
- Ornamen SVG inline (bukan emoji): pola geometris girih/bintang-8 sebagai latar tipis, bingkai ganda emas + ornamen sudut, bintang-8 kecil di atas ayat, pembatas emas + belah ketupat, flourish footer.
- Struktur vertikal: label kecil "Firman Allah" → ayat Arab (Amiri emas, besar) → pembatas → terjemahan (Poppins ivory) → referensi "QS. Surah : ayat" (emas, letter-spacing).
- Hindari gambar orang/hewan pada poster ayat — gunakan hanya tipografi + geometri.