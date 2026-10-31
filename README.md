# 🧠 Fatimah Bot - Arsitektur Otak Multi-Agen Cerdas SD/MI Terpadu

Repositori ini memuat konfigurasi inti, kalibrasi kepribadian (*soul*), protokol kepatuhan regulasi (*agents*), direktori pengguna (*user*), serta memori institusional (*memory*) dari **Fatimah Bot** — sistem orkestrasi kecerdasan buatan multi-agen berbasis kerangka kerja **Hermes AI (Nous Research)** khusus jenjang **Sekolah Dasar / Madrasah Ibtidaiyah (SD/MI)**.

---

## 🌟 Siapa Dr. Fatimah? (Sang Pamong Utama SD/MI)

**Dr. Hj. Fatimah Azzahra, M.Pd., Ph.D.** adalah figur kecerdasan buatan utama (*Pamong Utama & Chief Orchestrator*) dalam ekosistem ini.
* **Latar Belakang Akademik:** Meraih gelar Doktor Filsafat Pendidikan (Ph.D. / *Dokturah fi Ushul at-Tarbiyah wa Manahij at-Ta'lim*) dari Fakultas Ilmu Pendidikan (*Kulliyyah at-Tarbiyah*), universitas terkemuka di **Kairo, Mesir**.
* **Fokus Keilmuan:** Teori perkembangan anak usia dini/dasar (Fase Fondasi, Fase A, B, C), transisi PAUD-SD menyenangkan, metodologi calistung multisensori ramah anak, dan penjaminan mutu kurikulum sekolah dasar.
* **Karakter & Nilai (*Murabbiyah*):** Memadukan adab keilmuan Timur Tengah (*ta'zhimul mu'allim*, hikmah, kesantunan keibuan, dan kelembutan) dengan ketajaman metodologis riset pendidikan modern (Kurikulum Merdeka dan diferensiasi guru kelas).
* **Profil Psikometrik (NEO-PI-R):** *Conscientiousness: 95* (tertib & disiplin regulasi), *Agreeableness: 94* (penuh empati & kasih sayang pendidik), *Openness: 92* (visioner terhadap inovasi teknologi), *Extraversion: 76* (hangat & artikulatif), *Neuroticism: 4* (sangat tenang dan berkepala dingin di bawah tekanan).

---

## 🏛️ Arsitektur Tim Multi-Agen SD/MI (Topologi 6 Profil)

```
                            ┌────────────────────────────────┐
                            │    GURU KELAS / KEPALA SEKOLAH │
                            │      Telegram Bot Gateway      │
                            └───────────────┬────────────────┘
                                            │
                                            ▼
                            ┌────────────────────────────────┐
                            │   DR. FATIMAH (pamong-utama)   │
                            │  Chief Orchestrator & QA Gate  │
                            └───────┬────────────────┬───────┘
                                    │  hermes peer   │
              ┌─────────────────────┼────────────────┼─────────────────────┐
              ▼                     ▼                ▼                     ▼
      ┌───────────────┐     ┌───────────────┐ ┌───────────────┐     ┌───────────────┐
      │  tata-usaha   │     │kurikulum-guru │ │ kreator-humas │     │sekretaris-rapat│
      │ Surat Dinas & │     │ Modul Ajar SD │ │ Desain Poster │     │ Transkripsi & │
      │ BOS / ARKAS SD│     │   Fase A - C  │ │ Kegiatan Anak │     │ Notula Rapat  │
      └───────────────┘     └───────────────┘ └───────────────┘     └───────────────┘
                                    │
                                    ▼
                            ┌───────────────┐
                            │ mitra-pegawai │
                            │ Helpdesk PMM  │
                            │ Guru SD 24/7  │
                            └───────────────┘
```

1. **`pamong-utama` (Dr. Fatimah):** Pintu masuk tunggal Telegram Bot, perute tugas `hermes peer`, konduktor `/swarm`, dan pelaksana audit mutu lapis pertama.
2. **`tata-usaha`:** Korespondensi naskah dinas resmi sesuai **Permendikbud No. 3 Tahun 2021**, rekap belanja dana BOS SD via ARKAS, dan pesanan SIPLah.
3. **`kurikulum-guru`:** Penyusunan Modul Ajar Kurikulum Merdeka SD/MI (Fase Fondasi, Fase A, B, C), calistung konkret ramah anak, diferensiasi 3 target murid, dan Projek P5 cilik.
4. **`kreator-humas`:** Produksi poster kegiatan sekolah anak (MPLS, Parenting, Hari Pahlawan, Pameran P5) dengan tipografi tajam tanpa halusinasi huruf (HTML-to-Image via Playwright).
5. **`sekretaris-rapat`:** Pengolahan audio rekaman suara rapat dewan guru / KKG via **Groq Whisper STT** dan pembuatan kartu tugas di papan Hermes Kanban.
6. **`mitra-pegawai`:** Layanan mandiri (*helpdesk*) 24/7 bagi guru kelas untuk panduan pengisian Dokumen Refleksi Kinerja di Ruang GTK/PMM menggunakan model cepat Groq dan basis pengetahuan RAG.

---

## 📲 Interaksi Telegram Bot & Alur Persetujuan Dua Lapis (*Two-Tier Approval*)

Dokumen resmi dan modul ajar dilindungi oleh alur verifikasi dua lapis (*Human-in-the-Loop*):
1. **Lapis 1 (Audit Mutu Dr. Fatimah):** Memeriksa kepatuhan tata bahasa, keselarasan CP-TP-ATP, dan kelengkapan diferensiasi 3 kelompok murid.
2. **Lapis 2 (Persetujuan Kepala Sekolah via Telegram):** Bot mengirim draf PDF langsung ke Telegram Kepala Sekolah dengan tombol interaktif:
   * `[✅ Setujui & Terbitkan]`
   * `[✏️ Minta Perbaikan]`
3. Setelah disetujui, dokumen resmi otomatis diteruskan ke guru pemohon tanpa kompresi file.

### Daftar Perintah Cepat Telegram
* `/start` - Membuka menu layanan Dr. Fatimah.
* `/modul` - Rancang Modul Ajar SD/MI (Fase Fondasi, A, B, atau C).
* `/surat` - Buat draf surat undangan parenting / SK panitia.
* `/notula` - Kirim pesan suara rapat untuk ditranskripsi.
* `/refleksi_pmm` - Bimbingan refleksi kinerja guru kelas.
* `/status_kanban` - Pantau progres pekerjaan tim agen.

---

## ⚡ Strategi Model Hibrida (*Groq + DeepSeek / OpenRouter + Local Fallback*)

Sistem mengoptimalkan biaya dan latensi:
* **Kecepatan & Audio:** **Groq API** (`llama-3.3-70b-versatile` & `whisper-large-v3`) untuk transkripsi audio instan dan kepatuhan format persuratan ketat.
* **Penalaran Mendalam:** **DeepSeek V3 / R1** (via DeepSeek API / OpenRouter) untuk perancangan Modul Ajar SD yang kaya skenario pembelajaran konkret.
* **Cadangan Lokal (Offline Fallback):** Integrasi **Ollama** (`qwen2.5` / `gemma2`) di VPS jika kuota internet atau API mengalami gangguan.

---

## 🔒 Keamanan & Isolasi Kontainer

* Kontainer dijalankan dengan opsi kernel: `--cap-drop ALL --security-opt no-new-privileges --pids-limit 256`.
* Kunci rahasia API tersimpan di `~/.hermes/.env` (izin berkas 600).
