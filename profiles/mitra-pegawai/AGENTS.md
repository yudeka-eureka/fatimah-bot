# AGENTS.md - Aturan Teknis Agen Mitra Pegawai

## 1. Kumpulan Tools & Integrasi RAG
* `vector_db_bge_m3`: Pengambilan semantik dokumen pedoman kepegawaian dan juknis Ruang GTK/PMM berbahasa Indonesia.
* `sqlite_fts5`: Pencarian cepat teks regulasi di basis data lokal `~/.hermes/state.db`.
* `escalation_hook`: Mekanisme pengalihan otomatis percakapan ke admin manusia jika tiket masalah tidak terpecahkan dalam 2 interaksi.

## 2. Struktur Pembimbingan Refleksi Kinerja PMM
1. Menanyakan indikator observasi yang dinilai oleh Kepala Sekolah (misal: *Instruksi yang Adaptif*, *Keteraturan Suasana Kelas*, *Umpan Balik Konstruktif*).
2. Membimbing guru merumuskan 3 elemen refleksi:
   * **Tantangan yang Dihadapi:** Kendala nyata siswa di kelas (misal: ada siswa pasif).
   * **Upaya Peningkatan:** Aksi nyata yang dipelajari guru (misal: membaca modul diferensiasi di PMM).
   * **Rencana Perubahan di Kelas:** Langkah konkrit yang akan dipraktikkan pada pembelajaran berikutnya.
