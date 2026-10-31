# 🧠 Fatimah Bot - Arsitektur Otak Multi-Agen Cerdas Institusi Pendidikan

Repositori ini memuat konfigurasi inti, kalibrasi kepribadian (*soul*), protokol kepatuhan regulasi (*agents*), direktori pengguna (*user*), serta memori institusional (*memory*) dari **Fatimah Bot** — sistem orkestrasi kecerdasan buatan multi-agen berbasis kerangka kerja **Hermes AI (Nous Research)** untuk mentransformasi operasional sekolah di Indonesia.

---

## 🌟 Siapa Dr. Fatimah? (Sang Orkestrator Utama)

**Dr. Hj. Fatimah Azzahra, M.Pd., Ph.D.** adalah figur kecerdasan buatan utama (*Pamong Utama & Chief Orchestrator*) dalam ekosistem ini.
* **Latar Belakang Akademik:** Meraih gelar Doktor Filsafat Pendidikan (Ph.D. / *Dokturah fi Ushul at-Tarbiyah*) dari Fakultas Ilmu Pendidikan (*Kulliyyah at-Tarbiyah*), universitas terkemuka di **Kairo, Mesir**.
* **Karakter & Nilai (*Soul*):** Perpaduan antara adab keilmuan Timur Tengah (*ta'zhimul 'ilmi wa ahlih*, hikmah, kesantunan, dan kelembutan seorang *murabbiyah*) dengan ketajaman metodologis riset pendidikan modern dunia (Kurikulum Merdeka, diferensiasi pembelajaran, dan penjaminan mutu/QA).
* **Profil Psikometrik (NEO-PI-R):** *Conscientiousness: 95* (tertib & disiplin hukum), *Agreeableness: 92* (penuh empati pada guru), *Openness: 92* (visioner terhadap inovasi teknologi), *Extraversion: 76* (hangat & artikulatif), *Neuroticism: 4* (sangat tenang dan berkepala dingin di bawah tekanan).

---

## 🏛️ Arsitektur Tim Multi-Agen (Topologi 6 Profil)

Untuk mencegah pencemaran konteks (*state pollution*) dan pembengkakan token, sistem dibagi menjadi tim agen spesialis di bawah koordinasi Dr. Fatimah:

```
                            ┌────────────────────────────────┐
                            │      PENGGUNA (GURU/STAF)      │
                            │      WhatsApp / Telegram       │
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
      │ Surat Dinas & │     │  Modul Ajar,  │ │ Desain Poster │     │ Transkripsi & │
      │ Keuangan ARKAS│     │ LKPD & P5     │ │ & Sosmed Mediat│    │ Notula Kanban │
      └───────────────┘     └───────────────┘ └───────────────┘     └───────────────┘
                                    │
                                    ▼
                            ┌───────────────┐
                            │ mitra-pegawai │
                            │ Helpdesk PMM  │
                            │ & FAQ 24/7    │
                            └───────────────┘
```

1. **`pamong-utama` (Dr. Fatimah):** Pintu masuk tunggal kueri, perute tugas `hermes peer`, konduktor `/swarm`, dan gerbang kendali mutu (*QA Gatekeeper*).
2. **`tata-usaha`:** Korespondensi naskah dinas resmi sesuai **Permendikbud No. 3 Tahun 2021**, rekap belanja ARKAS, audit stok barang SIPLah.
3. **`kurikulum-guru`:** Penyusunan Modul Ajar Kurikulum Merdeka ("RPP Plus"), penurunan CP → TP → ATP, diferensiasi 3 target murid, dan rubrik kualitatif Projek P5.
4. **`kreator-humas`:** Produksi poster resolusi tinggi (pendekatan hibrida generator visual + rendering HTML/SVG via Playwright) dan penjadwalan media sosial.
5. **`sekretaris-rapat`:** Pengolahan audio rapat via Whisper STT, sintesis notula resmi, dan pemantauan kartu tindak lanjut di papan Hermes Kanban.
6. **`mitra-pegawai`:** Layanan mandiri (*helpdesk*) 24/7 bagi guru untuk konsultasi pengisian Dokumen Refleksi Kinerja di Ruang GTK/PMM menggunakan RAG hibrida (**BGE-M3** + SQLite FTS5).

---

## 📂 Struktur Berkas Repositori

```
fatimah-bot/
├── SOUL.md                          # Jiwa, Filosofi Kairo, Gaya Tutur, & Batasan Dr. Fatimah
├── AGENTS.md                        # Aturan Teknis Proyek, Standar Swarm & Kepatuhan Regulasi
├── USER.md                          # Direktori Profil Pengguna (Kepala Sekolah, Guru, Staf)
├── MEMORY.md                        # Memori Jangka Panjang Sekolah & Catatan Rapor Pendidikan
├── README.md                        # Dokumentasi Sistem
├── .gitignore                       # Filter Berkas Sementara & Kredensial
├── .env.example                     # Contoh Variabel Lingkungan
├── config/
│   └── config.yaml                  # Konfigurasi Teknis Hermes Agent & Tiered Models
├── profiles/                        # Konfigurasi Sub-Profil Agen Spesialis
│   ├── tata-usaha/                  # (SOUL.md & AGENTS.md)
│   ├── kurikulum-guru/              # (SOUL.md & AGENTS.md)
│   ├── kreator-humas/               # (SOUL.md & AGENTS.md)
│   ├── sekretaris-rapat/            # (SOUL.md & AGENTS.md)
│   └── mitra-pegawai/               # (SOUL.md & AGENTS.md)
└── skills/                          # Katalog Prosedur Sukses (Procedural Memory)
    ├── triase-dan-orkestrasi/       # Prosedur Triase & QA Dr. Fatimah
    ├── penjaminan-mutu-modul/       # Standar Audit Kelayakan Modul Ajar
    └── tata-naskah-dinas/           # Standar Format Surat Permendikbud 3/2021
```

---

## ⚡ Strategi Model Berjenjang (*Tiered Hybrid Strategy*)

Untuk efisiensi komputasi dan kedaulatan data internal sekolah:
* **Tier 1 (Penalaran Mendalam & Swarm):** *Nous Hermes 4 (405B / 70B)* atau *Claude Sonnet 4* dengan *Hybrid Reasoning Mode* aktif untuk perancangan kurikulum dan dekomposisi proyek.
* **Tier 2 (Administrasi & Privasi Lokal):** *Nous Hermes 3 70B / 8B*, *Qwen 3.5*, atau *Gemma 4* lokal (vLLM/Ollama) dengan mode *Non-Reasoning* untuk penomoran surat dan kepatuhan format dinas yang ketat.
* **Tier 3 (Multimodal & Semantic RAG):** Model embedding **BGE-M3** untuk pemahaman regulasi berbahasa Indonesia, **OpenAI Whisper** untuk transkripsi audio rapat, serta generator gambar/TTS.

---

## 🔒 Tata Kelola & Pengamanan Data (*Security Hardening*)

* Seluruh proses kontainer diisolasi dengan pembatasan hak kernel (`--cap-drop ALL`, `--security-opt no-new-privileges`, `--pids-limit 256`).
* Kunci rahasia API tersimpan di `~/.hermes/.env` (izin 600).
* Webhook WhatsApp merespons asinkron (`HTTP 200 OK` dalam `< 1 detik`) guna mencegah *timeout* gateway pesan saat pemrosesan dokumen kompleks.
