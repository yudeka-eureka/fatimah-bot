# USER.md - Profil & Direktori Pendidik SD/MI Terpadu

Dokumen ini memuat skema profil dan direktori pemangku kepentingan SD/MI yang terhubung melalui Telegram Bot Dr. Fatimah. Sistem memanfaatkan `telegram_user_id` untuk pemetaan identitas otomatis dan perutean tombol verifikasi (*Two-Tier Approval*).

---

## 1. Skema Data Profil Pengguna Telegram

```yaml
id: "USR-SD-001"
telegram_user_id: 123456789 # ID Telegram pengguna
username_telegram: "@ahmad_kepsek"
nama_lengkap: "Drs. H. Ahmad Dahlan, M.Pd."
sapaan_akrab: "Pak Ahmad"
peran_utama: "Kepala Sekolah"
nip_nuptk: "197204151998031004"
hak_akses: "ADMIN_FULL" # [ADMIN_FULL, KOORDINATOR_KURIKULUM, GURU_KELAS, GURU_MAPEL, OPERATOR_TU]
tugas_tambahan: "Penanggung Jawab ARKAS & Penandatangan Resmi SK Sekolah"
preferensi_komunikasi:
  gaya_bahasa: "Formal, ringkas, langsung pada keputusan"
  notifikasi_approval: true # Menerima tombol persetujuan inline Telegram
```

---

## 2. Buku Direktori Tenaga Pendidik & Kependidikan SD/MI

### A. Pimpinan Satuan Pendidikan & Koordinator
* **Drs. H. Ahmad Dahlan, M.Pd.**
  * **Peran:** Kepala Sekolah SD/MI
  * **Hak Akses:** `ADMIN_FULL`
  * **Wewenang:** Menerima tombol `[✅ Setujui & Terbitkan]` untuk seluruh draf SK dinas, laporan dana BOS, dan izin kegiatan luar kelas.
* **Nurul Hidayati, S.Pd., Gr.**
  * **Peran:** Koordinator Kurikulum Merdeka & Guru Penggerak
  * **Hak Akses:** `KOORDINATOR_KURIKULUM`
  * **Wewenang:** Menerima draf Modul Ajar dan rubrik P5 SD untuk verifikasi kelayakan sebelum disahkan Kepala Sekolah.

### B. Dewan Guru Kelas SD (Wali Kelas)
* **Siti Rahmawati, S.Pd.**
  * **Peran:** Guru Kelas 1 (Fase A - Transisi PAUD ke SD)
  * **Fokus:** Calistung ramah anak, motorik halus, pengenalan emosi dan adab dasar.
  * **Hak Akses:** `GURU_KELAS`
* **Dewi Anggraeni, S.Pd.**
  * **Peran:** Guru Kelas 2 (Fase A)
  * **Fokus:** Literasi membaca lancar, berhitung dasar penjumlahan/pengurangan konkret.
  * **Hak Akses:** `GURU_KELAS`
* **Budi Santoso, S.Pd.**
  * **Peran:** Guru Kelas 4 (Fase B)
  * **Fokus:** Pemahaman teks bacaan naratif/informasional, dasar IPAS, operasi perkalian/pembagian.
  * **Hak Akses:** `GURU_KELAS`
* **Zulkifli, M.Pd.**
  * **Peran:** Guru Kelas 6 (Fase C)
  * **Fokus:** Penalaran kritis, sains aplikatif, persiapan Asesmen Nasional (ANBK).
  * **Hak Akses:** `GURU_KELAS`

### C. Guru Mata Pelajaran Khusus & Tenaga Kependidikan
* **Ustadz Mansyur, S.Pd.I.**
  * **Peran:** Guru Pendidikan Agama Islam & Budi Pekerti (Fase A-C)
  * **Hak Akses:** `GURU_MAPEL`
* **Rahmat Hidayat, S.Kom.**
  * **Peran:** Operator Sekolah, Pengelola Dapodik & Aplikasi ARKAS BOS SD
  * **Hak Akses:** `OPERATOR_TU` (Akses langsung ke profil `tata-usaha`).

---

## 3. Aturan Resolusi Telegram ID
1. Saat guru pertama kali mengetik `/start` di Telegram Bot, Dr. Fatimah mencocokkan `telegram_user_id` dengan direktori ini.
2. Jika terdaftar sebagai Guru Kelas Fase A, Dr. Fatimah secara otomatis mengonfigurasi parameter kurikulum ke Fase A (pembelajaran multisensori dan asesmen calistung ramah anak).
3. Jika belum terdaftar, Dr. Fatimah menyapa santun sebagai tamu dan memberikan menu registrasi verifikasi guru oleh Operator Sekolah.
