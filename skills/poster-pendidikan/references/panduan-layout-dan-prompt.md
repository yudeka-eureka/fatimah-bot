# Panduan Tata Letak dan Templat Prompt Poster Pendidikan

Dokumen referensi ini memuat rincian komposisi visual serta templat prompt siap pakai untuk menghasilkan poster pendidikan bergaya ilustrasi anak 2D dalam format **Landscape** maupun **Portrait**.

## 1. Spesifikasi Palet Warna dan Elemen Visual

- **Langit dan Latar**: Biru langit cerah (`#87CEEB` ke `#B0E2FF`), awan putih lembut, matahari kuning cerah (`#FFD700`) dengan ekspresi wajah tersenyum di sudut kanan atas, cabang pohon hijau di sudut kiri atas.
- **Pita Pembuka Atas**: Biru dongker tua (`#1B3B6F`) dengan teks putih tebal.
- **Judul Utama (Sticker Text)**: Huruf tebal membulat dengan garis tepi putih tebal. Warna huruf bergantian (Biru `#1565C0`, Hijau `#43A047`, Oranye `#FB8C00`, Ungu `#8E24AA`) dan kata penekanan berwarna Merah Koral (`#E91E63`).
- **Pita Sub-Judul**: Merah muda cerah (`#EC407A`) dengan teks putih.
- **Kotak Kapsul Poin (Urutan Warna Pastel)**:
  1. Kuning Pastel (`#FFF3B0`) + Ikon Lingkaran Kuning (`#FDD835`)
  2. Hijau Pastel (`#DCEDC8`) + Ikon Lingkaran Hijau (`#7CB342`)
  3. Biru Muda Pastel (`#B3E5FC`) + Ikon Lingkaran Biru/Merah
  4. Ungu Lavender Pastel (`#E1BEE7`) + Ikon Lingkaran Merah Muda (`#EC407A`)
  5. Persik Pastel (`#FFCCBC`) + Ikon Lingkaran Oranye Muda (`#FFB74D`)
- **Footer Bawah**: Biru dongker tua (`#16325C`) dengan teks putih di kiri dan lencana stiker putih berbingkai garis putus-putus di kanan bawah.

## 2. Templat Prompt Orientasi Landscape (Rasio 16:9 atau 4:3)

Gunakan templat berikut saat memanggil `image_gen:generate_image` dengan `aspect_ratio: "16:9"` atau `"4:3"`:

```text
Cheerful 2D Indonesian children's educational poster illustration, clean vector cartoon style, bright and pastel colors, horizontal landscape layout.

BACKGROUND: Bright blue sky with soft white clouds, a cute smiling yellow sun in the top right corner, green leafy tree branch in the top left corner, lush green grass and small flowers at the bottom. On the right background stands a neat Indonesian school building with an orange roof, round clock, a sign reading "SEKOLAH", and the Indonesian red-and-white flag fluttering on a flagpole.

TOP HEADER (CENTERED):
- Top dark navy blue curved ribbon banner with bold white uppercase text: "[TEKS_PITA_ATAS]"
- Below it, extra-bold chunky 3D rounded cartoon title letters with a thick white sticker outline and colorful letters: "[JUDUL_UTAMA]", flanked by a small blue paper airplane with a dashed loop line on the left and a white heart doodle on the right.
- Directly underneath, a bright pink ribbon banner with clean bold white text: "[TEKS_PENGANTAR_POIN]"

LEFT COLUMN (STACKED PASTEL PILL BOXES):
Five horizontal rounded pill cards stacked vertically on the left side, each with a thick white border, a circular icon badge on the left end, and bold dark navy blue text inside:
1. Pastel yellow box with smiling face icon badge: "[POIN_1]"
2. Pastel green box with shield checkmark icon badge: "[POIN_2]"
3. Pastel light blue box with [IKON_3] icon badge: "[POIN_3]"
4. Pastel lavender box with red heart icon badge: "[POIN_4]"
5. Pastel peach box with open book and lightbulb icon badge: "[POIN_5]"

RIGHT COLUMN (CHARACTERS & SLOGAN BANNER):
In front of the school building, happy Indonesian school children wearing [JENJANG_SERAGAM] uniforms (including a smiling girl in a white hijab and boys and girls with backpacks) waving cheerfully and holding a large white rectangular sign together. The white sign features colorful bold text reading: "[TEKS_SLOGAN_SPANDUK]" decorated with small star, heart, and smiley face doodles.

BOTTOM FOOTER BAR:
A dark navy blue curved footer wave across the bottom with small flowers, a yellow star, an open book, and a yellow school backpack on the right.
- Left footer text in bold white: "[TEKS_KALIMAT_PENUTUP]"
- Bottom right corner features a white rounded rectangle sticker badge with a dashed border and bold colorful text: "[TEKS_LENCANA_BAWAH]"
All Indonesian text must be spelled accurately, crisp, and clearly legible.
```

## 3. Templat Prompt Orientasi Portrait (Rasio 3:4 atau 4:5)

Gunakan templat berikut saat memanggil `image_gen:generate_image` dengan `aspect_ratio: "3:4"` atau `"4:5"`:

```text
Cheerful 2D Indonesian children's educational poster illustration, clean vector cartoon style, bright and pastel colors, vertical portrait layout.

TOP ZONE (HEADER & SKY):
Bright blue sky background with soft clouds, green tree leaves in the top left corner, and a cute smiling yellow sun in the top right corner.
- Top dark navy blue curved ribbon banner with bold white uppercase text: "[TEKS_PITA_ATAS]"
- Below it, extra-bold chunky 3D rounded cartoon title letters with a thick white sticker outline and colorful letters: "[JUDUL_UTAMA]", with a small blue paper airplane on the left and a heart doodle on the right.
- Directly underneath, a bright pink ribbon banner with bold white text: "[TEKS_PENGANTAR_POIN]"

UPPER-MIDDLE ZONE (STACKED PASTEL PILL BOXES):
Centered vertically below the header, horizontal rounded pill cards stacked neatly, each with a thick white border, a circular icon badge on the left end, and bold dark navy blue text inside:
1. Pastel yellow box with smiling face icon badge: "[POIN_1]"
2. Pastel green box with shield checkmark icon badge: "[POIN_2]"
3. Pastel light blue box with [IKON_3] icon badge: "[POIN_3]"
4. Pastel lavender box with red heart icon badge: "[POIN_4]"
5. Pastel peach box with open book and lightbulb icon badge: "[POIN_5]"

LOWER-MIDDLE ZONE (SCHOOL & STUDENTS WITH SLOGAN BANNER):
Below the pill boxes, an Indonesian school building with an orange roof, clock tower, "SEKOLAH" sign, and Indonesian red-and-white flag on a flagpole. In the foreground on green grass with flowers, cheerful Indonesian students in [JENJANG_SERAGAM] uniforms (including a girl in a white hijab and students with backpacks) smile and hold a large white rectangular banner with colorful bold text: "[TEKS_SLOGAN_SPANDUK]" decorated with cute stars and heart doodles.

BOTTOM ZONE (FOOTER BAR):
A dark navy blue curved footer wave across the very bottom with small flowers, a yellow star, and a yellow backpack.
- Left side of footer in bold white text: "[TEKS_KALIMAT_PENUTUP]"
- Right side of footer features a white rounded rectangular sticker badge with a dashed border reading: "[TEKS_LENCANA_BAWAH]"
All Indonesian text must be spelled accurately, crisp, and clearly legible.
```
