# USER.md - Profil & Konteks Pengguna (Tenaga Pendidik & Kependidikan)

Dokumen ini memuat skema profil dan data identitas pemangku kepentingan sekolah yang berinteraksi dengan Dr. Fatimah dan tim agen. Data ini digunakan untuk mempersonalisasi bahasa sapaan, penyesuaian fase kurikulum, dan otorisasi hak akses (*role-based scoping*).

---

## 1. Skema Data Profil Pengguna

Setiap pengguna yang terhubung melalui nomor WhatsApp atau akun Telegram memiliki rekaman profil dengan format berikut:

```yaml
id: "USR-001"
nama_lengkap: "Drs. H. Ahmad Dahlan, M.Pd."
sapaan_akrab: "Pak Ahmad"
peran_utama: "Kepala Sekolah"
nomor_telepon: "+6281234567890"
nip_nuptk: "196805121994031002"
hak_akses: "ADMIN_FULL" # [ADMIN_FULL, BENDAHARA_TU, GURU_MAPEL, STAF_UMUM]
spesialisasi:
  mata_pelajaran: null
  fase_kurikulum: null
  tugas_tambahan: "Penanggung Jawab ARKAS & PPK Satuan Pendidikan"
preferensi_komunikasi:
  gaya_bahasa: "Formal, ringkas, langsung pada keputusan"
  format_dokumen_disukai: "PDF siap cetak & ringkasan poin WA"
```

---

## 2. Buku Direktori Pengguna Sekolah (Contoh Terdaftar)

### A. Pimpinan Satuan Pendidikan & Tata Usaha
* **Nama:** Drs. H. Ahmad Dahlan, M.Pd.
  * **Peran:** Kepala Sekolah (Otoritas Tertinggi Pengesahan Dokumen & Anggaran)
  * **Hak Akses:** `ADMIN_FULL` (Dapat menyetujui draft SK, mutasi anggaran ARKAS, dan surat dinas luar).
* **Nama:** Siti Nurhaliza, S.Sos.
  * **Peran:** Kepala Tata Usaha (KTU) & Pengelola Inventaris
  * **Hak Akses:** `BENDAHARA_TU` (Akses penuh ke profil `tata-usaha` untuk penomoran surat & cek stok SIPLah).
* **Nama:** Rahmat Hidayat, S.E.
  * **Peran:** Bendahara BOS / Operator ARKAS
  * **Hak Akses:** `BENDAHARA_TU` (Akses data rekening belanja BOS, rekonsiliasi SPJ, dan BKU).

### B. Dewan Guru & Pendidik
* **Nama:** Nurul Hidayati, S.Pd.
  * **Peran:** Guru Penggerak / Guru Bahasa Indonesia
  * **Fase Kurikulum:** Fase D (SMP Kelas 7-9)
  * **Tugas Tambahan:** Koordinator Projek Penguatan Profil Pelajar Pancasila (P5)
  * **Hak Akses:** `GURU_MAPEL`
* **Nama:** Budi Santoso, S.Si., Gr.
  * **Peran:** Guru Matematika & Informatika
  * **Fase Kurikulum:** Fase E & F (SMA Kelas 10-12)
  * **Tugas Tambahan:** Tim Kurikulum & Pembina Olimpiade Sains
  * **Hak Akses:** `GURU_MAPEL`
* **Nama:** Dewi Sartika, S.Pd.
  * **Peran:** Guru Seni Budaya & Prakarya
  * **Fase Kurikulum:** Fase D
  * **Tugas Tambahan:** Tim Publikasi & Pengelola Media Sosial Sekolah
  * **Hak Akses:** `GURU_MAPEL` (Memiliki izin kolaborasi dengan profil `kreator-humas`).

---

## 3. Aturan Resolusi Identitas Pengguna (*Identity Resolution Rules*)

1. **Pemetaan Otomatis Berbasis Nomor Telepon (`thread_id`):**
   * Saat pesan masuk dari WhatsApp/Telegram diterima oleh `pamong-utama` (Dr. Fatimah), sistem mencocokkan nomor pengirim dengan basis data `USER.md` atau tabel pengguna di PostgreSQL.
   * Jika nomor terdaftar, Dr. Fatimah langsung menyapa dengan nama dan gelar yang sesuai, serta mengaktifkan batasan hak akses yang melekat pada profil tersebut.
2. **Penanganan Pengguna Baru (Tamu / Wali Murid / Guru Baru):**
   * Jika nomor pengirim belum tercatat, Dr. Fatimah mengaktifkan profil `TAMU_UMUM` dengan hak akses terbatas (hanya informasi publik PPDB, jadwal kegiatan sekolah, dan sambutan pengantar).
   * Dr. Fatimah akan meminta konfirmasi nama dan unit kerja sebelum memberikan bantuan administratif internal.
