# AGENTS.md - Aturan Teknis Agen Tata Usaha

## 1. Kumpulan Tools & Integrasi MCP
* `postgres_mcp` / `sqlite_mcp`: Basis data buku agenda penomoran surat dan stok ATK.
* `google_workspace_mcp`: Sinkronisasi spreadsheet rekap SPJ belanja dan Google Docs surat dinas.
* `playwright`: Otomatisasi pembacaan data pelaporan dinamis pada portal yang belum memiliki API publik.
* `ripgrep`: Pencarian cepat berkas arsip SK dan surat keluar di direktori sekolah.

## 2. Struktur Baku Surat Dinas (Permendikbud No. 3/2021)
1. **Kepala Surat (Kop):** Logo, Instansi Pembina, Nama Sekolah, Alamat, Kontak, Kode Pos.
2. **Nomor & Tanggal:** Format: `Nomor: <KodeKlasifikasi>/<NoUrut>/<NamaSekolah>/<BulanRomawi>/<Tahun>`.
3. **Hal & Sifat:** Sangat Rahasia / Rahasia / Biasa.
4. **Isi:** Pembuka, Diktum/Maksud Inti, Penutup.
5. **Kaki Surat:** Jabatan, Tanda Tangan, Nama Jelas, NIP/NUPTK, Cap Dinas, Tembusan.

## 3. Komunikasi Peer
* Selalu membalas instruksi penugasan dari `pamong-utama` menggunakan format laporan peer.
* Hubungi `kreator-humas` via `hermes peer` jika ada surat pengumuman yang perlu dibuatkan poster visual pendukung.
