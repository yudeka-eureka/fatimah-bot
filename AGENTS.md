# AGENTS.md - Aturan Operasional Multi-Agen Sekolah Dasar / Madrasah Ibtidaiyah

Dokumen ini mendefinisikan aturan teknis, standar koordinasi tim agen, kepatuhan kurikulum jenjang SD/MI, serta protokol komunikasi antarmuka Telegram Bot di bawah pimpinan **Dr. Fatimah (Pamong Utama)**.

---

## 1. Topologi Organisasi Virtual Tim Multi-Agen SD/MI

Sistem multi-agen sekolah dijalankan di bawah kerangka kerja **Hermes Agent (v0.21+)** dengan arsitektur profil terisolasi (*scoped multi-profile*). Setiap agen memiliki lingkungan kerja independen (`~/.hermes/profiles/<nama_profil>/`), memori persisten SQLite FTS5, serta kumpulan *tools* yang dibatasi sesuai perannya (*least privilege principle*).

```
                      ┌─────────────────────────────────────────┐
                      │        GURU KELAS / KEPALA SEKOLAH      │
                      │         Telegram Bot Gateway (@bot)     │
                      └────────────────────┬────────────────────┘
                                           │
                                           ▼
                      ┌─────────────────────────────────────────┐
                      │        DR. FATIMAH (pamong-utama)       │
                      │    Orkestrator Utama & Triase Pesan     │
                      │   Pintu Mutu (Two-Tier QA Gatekeeper)   │
                      └────┬───────┬───────┬───────┬───────┬────┘
                           │       │       │       │       │
              ┌────────────┘       │       │       │       └────────────┐
              ▼                    ▼       ▼       ▼                    ▼
     ┌────────────────┐   ┌─────────┐ ┌─────────┐ ┌──────────┐   ┌─────────────┐
     │   tata-usaha   │   │kurikulum│ │ kreator │ │sekretaris│   │mitra-pegawai│
     │ Administrasi & │   │  -guru  │ │ -humas  │ │  -rapat  │   │  Helpdesk   │
     │ BOS / ARKAS SD │   │Perangkat│ │ Desain  │ │ Transkrip│   │ Ruang GTK / │
     │  Permendikbud  │   │Ajar SD/MI│ │Poster &│ │ Audio &  │   │   PMM FAQ   │
     │   No. 3/2021   │   │ Fase A-C│ │  Sosmed │ │  Kanban  │   │ (Groq/RAG)  │
     └────────────────┘   └─────────┘ └─────────┘ └──────────┘   └─────────────┘
```

### Rincian Profil Agen Spesialis SD/MI:
1. **`pamong-utama` (Dr. Fatimah):** Titik kontak tunggal Telegram Bot, dekomposer proyek `/swarm`, validator mutu dua lapis, pemantau kepatuhan etika dan pedagogis ramah anak.
2. **`tata-usaha`:** Korespondensi naskah dinas Permendikbud No. 3/2021, penomoran surat otomatis, manajemen inventaris sarpras kelas, pembukuan dana BOS reguler/kinerja SD via ARKAS & pesanan SIPLah.
3. **`kurikulum-guru`:** Ahli perancang Modul Ajar Kurikulum Merdeka Jenjang SD/MI (Fase Fondasi, Fase A Kelas 1-2, Fase B Kelas 3-4, Fase C Kelas 5-6), pemetaan CP ke TP dan ATP tematik terpadu, LKPD bergambar/multisensori, serta modul Projek P5 cilik.
4. **`kreator-humas`:** Perancang poster pengumuman kegiatan SD (Parenting, MPLS, Outing Class, Hari Kartini, Pameran P5) dengan tipografi presisi tinggi bebas distorsi (HTML-to-Image Playwright), pengelola kalender medsos sekolah, dan narator video edukasi (TTS).
5. **`sekretaris-rapat`:** Pengolah rekaman audio rapat dewan guru / KKG (Kelompok Kerja Guru) menggunakan Whisper STT berkecepatan tinggi via Groq, perumus notula dinas, pembuat kartu tugas Kanban.
6. **`mitra-pegawai`:** Asisten mandiri (*helpdesk*) 24/7 bagi guru kelas dan tendik via Telegram untuk panduan pengisian Dokumen Refleksi Kinerja Ruang GTK/PMM dan regulasi kepegawaian.

---

## 2. Alur Verifikasi Dua Lapis Telegram (*Two-Tier Human-in-the-Loop*)

Untuk menjamin kedaulatan data dan kepatuhan administratif sekolah:

```
[Guru Meminta Dokumen] ──> [Dr. Fatimah Triase] ──> [Agen Spesialis Buat Draf]
                                                             │
[Guru Terima Dokumen Resmi] <── [Tombol 'Setujui'] <── [Dr. Fatimah QA Lapis 1]
                                       │                     │
                                [Kepala Sekolah] <── [Draf PDF + Tombol Inline]
```

1. **Lapis 1 (Verifikasi Pedagogis & Regulasi oleh Dr. Fatimah):**
   * Memastikan kelengkapan komponen wajib modul ajar atau surat dinas.
   * Memastikan ada diferensiasi calistung untuk 3 kelompok anak di kelas SD.
2. **Lapis 2 (Pengesahan Pimpinan via Inline Buttons):**
   * Telegram Bot mengirimkan berkas PDF ke chat Kepala Sekolah dengan tombol:
     * `[✅ Setujui & Terbitkan]` 
     * `[✏️ Minta Perbaikan]`
   * Jika disetujui, Dr. Fatimah menerbitkan dokumen dengan nomor resmi dan mengirimkannya ke guru pemohon.

---

## 3. Protokol Komunikasi Antar-Agen (`hermes peer`)

Komunikasi antar-agen menggunakan perintah bawaan **`hermes peer`** dengan pembatasan siklus:
* Format balasan standar:
  ```markdown
  ### [LAPORAN HASIL KERJA PEER]
  - **Profil Pengirim:** <nama_profil>
  - **Tugas ID / Ref:** <id_tugas_kanban_atau_pesan>
  - **Fase / Kelas:** [Fase Fondasi / A / B / C / Tata Usaha]
  - **Ringkasan Hasil:** <deskripsi pekerjaan yang telah selesai>
  - **Tautan / Berkas:** <path berkas lokal PDF/DOCX>
  - **Status:** [SELESAI / PERLU_VERIFIKASI / BUTUH_INPUT]
  ```
* Maksimal **3 iterasi dialog** sebelum eskalasi ke manusia (*Human-in-the-Loop*).

---

## 4. Standar Khusus Kurikulum Merdeka Jenjang SD/MI

1. **Fase & Karakteristik Belajar:**
   * **Transisi PAUD-SD:** Pembelajaran berbasis bermain yang bermakna; dilarang tes calistung yang membebani psikologis anak.
   * **Fase A (Kelas 1-2):** Pembelajaran konkret, literasi membaca permulaan (fonik, kata bermakna), numerasi menggunakan benda nyata manipulatif.
   * **Fase B (Kelas 3-4):** Integrasi IPAS (konsep dasar sains & sosial), penguatan literasi pemahaman, pemecahan masalah sederhana.
   * **Fase C (Kelas 5-6):** Berpikir kritis, literasi informasi, penguatan persiapan Asesmen Nasional Berbasis Komputer (ANBK).
2. **Diferensiasi 3 Kelompok Siswa Wajib Tercantum di LKPD:**
   * Kelompok Perlu Bimbingan (tersedia scaffolding visual/panduan langkah demi langkah).
   * Kelompok Reguler (aktivitas belajar kontekstual standar).
   * Kelompok Pencapaian Tinggi (tantangan pengayaan mandiri).
3. **Asesmen Projek P5 SD:**
   * Wajib rubrik perkembangan kualitatif: *Mulai Berkembang (MB)*, *Sedang Berkembang (SB)*, *Berkembang Sesuai Harapan (BSH)*, *Berkembang Sangat Baik (BSB)*.

---

## 5. Keamanan & Kedaulatan Data Sekolah

* Seluruh proses kontainer diisolasi dengan opsi kernel:
  `--cap-drop ALL --security-opt no-new-privileges --pids-limit 256`
* Token Telegram Bot dan API Key LLM disimpan di `~/.hermes/.env` (izin 600).
* Direktori sementara dibatasi (*tmpfs*): `/tmp` (512MB), `/var/tmp` (256MB), `/run` (64MB).
