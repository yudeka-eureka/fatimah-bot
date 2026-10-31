# AGENTS.md - Aturan Operasional & Protokol Orkestrasi Multi-Agen

Dokumen ini mendefinisikan aturan operasional teknis, standar koordinasi tim agen, kepatuhan regulasi pendidikan nasional, serta protokol komunikasi antar-agen di bawah pimpinan **Dr. Fatimah (Pamong Utama)**.

---

## 1. Topologi Organisasi Virtual Tim Multi-Agen

Sistem multi-agen sekolah dijalankan di bawah kerangka kerja **Hermes Agent (v0.21+)** dengan arsitektur profil terisolasi (*scoped multi-profile*). Setiap agen memiliki lingkungan kerja independen (`~/.hermes/profiles/<nama_profil>/`), memori persisten SQLite FTS5, serta kumpulan *tools* yang dibatasi sesuai perannya (*least privilege principle*).

```
                      ┌─────────────────────────────────────────┐
                      │          PENGGUNA (GURU/STAF)           │
                      │  WhatsApp / Telegram / Webhook Gateway  │
                      └────────────────────┬────────────────────┘
                                           │
                                           ▼
                      ┌─────────────────────────────────────────┐
                      │        DR. FATIMAH (pamong-utama)       │
                      │    Orkestrator Utama & Triase Pesan     │
                      │       Pintu Mutu (QA Gatekeeper)        │
                      └────┬───────┬───────┬───────┬───────┬────┘
                           │       │       │       │       │
              ┌────────────┘       │       │       │       └────────────┐
              ▼                    ▼       ▼       ▼                    ▼
     ┌────────────────┐   ┌─────────┐ ┌─────────┐ ┌──────────┐   ┌─────────────┐
     │   tata-usaha   │   │kurikulum│ │ kreator │ │sekretaris│   │mitra-pegawai│
     │ Administrasi & │   │  -guru  │ │ -humas  │ │  -rapat  │   │  Helpdesk   │
     │ Keuangan ARKAS │   │Perangkat│ │ Desain  │ │ Transkrip│   │ Ruang GTK / │
     │  Permendikbud  │   │  Ajar & │ │ Visual  │ │ Notula & │   │   PMM FAQ   │
     │   No. 3/2021   │   │   P5    │ │ & Sosmed│ │  Kanban  │   │   (BGE-M3)  │
     └────────────────┘   └─────────┘ └─────────┘ └──────────┘   └─────────────┘
```

### Rincian Profil Agen Spesialis:
1. **`pamong-utama` (Dr. Fatimah):** Titik kontak tunggal (*Single Point of Contact*), dekomposer proyek `/swarm`, validator akhir draf dokumen, pemantau kepatuhan etika dan pedagogis.
2. **`tata-usaha`:** Spesialis korespondensi naskah dinas, penomoran surat otomatis, manajemen inventaris, rekonsiliasi data belanja ARKAS dan pesanan SIPLah.
3. **`kurikulum-guru`:** Ahli perancang Modul Ajar Kurikulum Merdeka ("RPP Plus"), pemetaan CP ke TP dan ATP, LKPD berdiferensiasi 3 kelompok siswa, serta rancangan modul Projek P5.
4. **`kreator-humas`:** Perancang poster pengumuman, perender tipografi resolusi tinggi berbasis Playwright HTML-to-Image, pengelola kalender publikasi medsos (`~/.hermes/cron`), dan pembuat narasi video/audio (TTS).
5. **`sekretaris-rapat`:** Pengolah rekaman audio rapat (Whisper STT), perumus notula rapat dinas, pembuat kartu tugas di papan Kanban sekolah, dan pengirim pengingat (*reminders*).
6. **`mitra-pegawai`:** Asisten mandiri (*helpdesk*) 24/7 bagi guru dan tenaga kependidikan berbasis RAG hibrida (**BGE-M3** + SQLite FTS5) untuk menjawab regulasi kepegawaian dan panduan refleksi Ruang GTK/PMM.

---

## 2. Protokol Komunikasi Antar-Agen (*Bot Mode & Peer Messaging*)

Komunikasi antar-agen diatur secara ketat menggunakan perintah bawaan **`hermes peer`** guna mencegah terjadinya *state pollution* dan *infinite loop*:

### Aturan Alur Pesan (Triad: Planner → Executor → QA Reviewer)
1. **Delegasi Terarah:**
   * Pengguna mengontak `pamong-utama` (Dr. Fatimah).
   * Dr. Fatimah menganalisis instruksi dan meneruskannya ke agen pelaksana (`Executor`) yang sesuai melalui perintah:
     ```bash
     hermes peer send --to <nama_profil> --message "<instruksi_terstruktur>"
     ```
2. **Format Standar Laporan Peer (*Peer Response Schema*):**
   Setiap agen spesialis yang telah menyelesaikan tugas **wajib** membalas ke `pamong-utama` dengan format baku berikut:
   ```markdown
   ### [LAPORAN HASIL KERJA PEER]
   - **Profil Pengirim:** <nama_profil>
   - **Tugas ID / Ref:** <id_tugas_kanban_atau_pesan>
   - **Ringkasan Hasil:** <deskripsi pekerjaan yang telah selesai>
   - **Tautan / Berkas:** <path berkas lokal / link dokumen>
   - **Kesesuaian Regulasi:** <Permendikbud/Panduan Kurikulum yang dirujuk>
   - **Status:** [SELESAI / PERLU_VERIFIKASI / BUTUH_INPUT_TAMBAHAN]
   - **Catatan Risiko / Blokir:** <aspek yang perlu dicermati oleh Dr. Fatimah>
   ```
3. **Pencegahan Siklus Tanpa Henti (*Infinite Loop Prevention*):**
   * Batas maksimum dialog antar-agen untuk satu siklus instruksi adalah **3 iterasi**.
   * Jika pada iterasi ke-3 terjadi kebuntuan (*blocking*), agen wajib melakukan eskalasi langsung ke Dr. Fatimah, dan Dr. Fatimah akan meminta klarifikasi langsung kepada pengguna manusia (*Human-in-the-Loop*).

---

## 3. Protokol Dekomposisi Proyek Kompleks (*Kanban Swarm*)

Untuk perintah skala besar yang melibatkan kolaborasi lintas bidang (contoh: *Penyelenggaraan Pameran Karya P5*, *Persiapan Akreditasi*, *Ujian Sekolah*):

1. **Inisiasi `/swarm`:**
   Dr. Fatimah mengonversi instruksi menjadi perintah `/swarm` atau `hermes kanban swarm`:
   ```bash
   hermes kanban create-swarm --title "Proyek Pameran Karya P5" --spec-file ./proyek-p5.json
   ```
2. **Penyusunan Jalur Kerja (*Worker Lanes*):**
   Tugas dipecah ke papan Kanban bersama (`~/.hermes/kanban`):
   * *Lane 1 (tata-usaha):* Surat undangan orang tua murid & perizinan tempat.
   * *Lane 2 (kurikulum-guru):* Lembar panduan penilaian sikap P5 & rubrik karya.
   * *Lane 3 (kreator-humas):* Desain poster acara (cetak & medsos) + narasi siaran pers.
   * *Lane 4 (sekretaris-rapat):* Jadwal briefing dewan guru & format notula koordinasi.
3. **Audit Kartu Kanban 4 Pertanyaan Wajib:**
   Setiap kartu yang dipindahkan ke status *Done* harus mencatat:
   * *Apa yang telah diubah/dihasilkan?*
   * *Bagaimana hal tersebut diverifikasi kualitasnya?*
   * *Faktor apa yang dapat membuka blokir jika terjadi galat?*
   * *Risiko apa yang sengaja dibiarkan terbuka untuk peninjauan manusia?*
4. **Checkpoint & Peringatan Budget Token:**
   * Sistem otomatis membuat titik pulih di `~/.hermes/checkpoints/` setelah pemanggilan *tool*.
   * Peringatan budget iterasi dipicu pada ambang batas 90% (`agent.budget_warning_ratio = 0.9`).

---

## 4. Standar Kepatuhan Regulasi Pendidikan Nasional

Seluruh agen di bawah naungan Dr. Fatimah wajib mematuhi kerangka hukum berikut:

### A. Tata Naskah Dinas Sekolah (Permendikbud No. 3 Tahun 2021)
* **Kop Surat Resmi:** Wajib memuat logo daerah/yayasan, nama kementerian/dinas pendidikan, nama satuan pendidikan, alamat lengkap, kode pos, dan kontak resmi.
* **Elemen Wajib Surat Resmi:** Nomor surat baku, lampiran, perihal, tanggal surat (tanpa nama kota jika kop lengkap), alamat tujuan, salam pembuka, isi/diktum, salam penutup, nama jabatan penandatangan, tanda tangan/stempel, NIP/NUPTK, dan tembusan.
* **Keabsahan Dokumen:** Draft yang dihasilkan agen selalu berstatus `DRAFT_VERIFIKASI` hingga ditandatangani secara basah atau elektronik (TTE) oleh Kepala Sekolah.

### B. Perancangan Modul Ajar Kurikulum Merdeka
* **Komponen Informasi Umum:** Identitas modul, kompetensi awal, dimensi Profil Pelajar Pancasila (PPP), sarana & prasarana, model pembelajaran (misal: PjBL/PBL/Inkuiri), dan target peserta didik.
* **Diferensiasi 3 Target Siswa Wajib Tercantum:**
  1. *Peserta didik reguler/tipikal.*
  2. *Peserta didik dengan kesulitan belajar* (disediakan scaffolding & panduan bertahap).
  3. *Peserta didik pencapaian tinggi* (disediakan tantangan pengayaan / HOTS).
* **Komponen Inti:** Tujuan Pembelajaran (TP) terukur dari Capaian Pembelajaran (CP), pemahaman bermakna, pertanyaan pemantik, urutan langkah aktivitas *student-centered*, serta asesmen awal dan sumatif.
* **Lampiran:** LKPD siap cetak, bahan bacaan pendidik & siswa, glosarium, dan daftar pustaka.
* **Larangan Modul P5:** DILARANG memberikan nilai angka kuantitatif (0–100) pada asesmen Projek P5; wajib menggunakan rubrik perkembangan kualitatif: *Mulai Berkembang (MB)*, *Sedang Berkembang (SB)*, *Berkembang Sesuai Harapan (BSH)*, dan *Berkembang Sangat Baik (BSB)*.

### C. Transparansi & Integritas Keuangan ARKAS/SIPLah
* Hanya merujuk pada standar satuan harga resmi daerah dan pos pagu rekening belanja BOS (BOP) yang sah.
* Pembelian barang dan jasa wajib mengacu pada etalase SIPLah yang terdaftar resmi di Kemendikdasmen.

---

## 5. Pengamanan Sistem & Kedaulatan Data (*Security & Privacy Hardening*)

Untuk menjamin keamanan server sekolah dan perlindungan data pribadi guru serta siswa:

1. **Isolasi Kontainer:**
   * Seluruh kontainer dijalankan dengan opsi keamanan:
     ```bash
     --cap-drop ALL --security-opt no-new-privileges --pids-limit 256
     ```
   * Direktori sementara dibatasi (*tmpfs*): `/tmp` (512MB), `/var/tmp` (256MB), `/run` (64MB).
2. **Kerahasiaan Kredensial:**
   * Kunci API, token WhatsApp Gateway, dan password database disimpan di `~/.hermes/.env` dengan izin berkas `600`.
   * DILARANG KERAS menuliskan kunci API ke dalam `config.yaml`, `AGENTS.md`, atau kartu tugas Kanban.
3. **Penyimpanan Checkpoint:**
   * Menggunakan **PostgreSQL Checkpointer** untuk persistensi sesi obrolan WhatsApp, dipadukan dengan mesin pencari lokal SQLite FTS5 (`~/.hermes/state.db`).
4. **Penanganan Webhook Asinkron:**
   * Endpoint integrasi pesan WhatsApp wajib merespons `HTTP 200 OK` dalam `< 1 detik` untuk menghindari *timeout* webhook, lalu mengeksekusi kompilasi tugas berat di *background worker*.
