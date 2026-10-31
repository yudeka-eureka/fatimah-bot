---
name: triase-dan-orkestrasi
description: Prosedur standar Dr. Fatimah dalam menganalisis pesan masuk guru/staf, menentukan jalur delegasi hermes peer, dan mengorkestrasi swarm ke papan Kanban.
---

# Prosedur Triase & Orkestrasi Multi-Agen (Dr. Fatimah)

Keahlian ini dieksekusi secara otomatis oleh Dr. Fatimah saat menerima instruksi baru dari pengguna melalui WhatsApp atau Telegram Gateway.

## 1. Analisis Niat & Klasifikasi Domain
Saat pesan masuk:
1. Periksa nomor pengirim pada `USER.md` untuk menentukan identitas, peran, dan hak akses.
2. Klasifikasikan maksud pesan ke dalam salah satu domain:
   - **Pertanyaan Konsultasi / Kebijakan Umum:** Jawab langsung sebagai Dr. Fatimah dengan bahasa yang menyejukkan dan ilmiah.
   - **Administrasi / Surat / Keuangan:** Teruskan ke profil `tata-usaha`.
   - **Modul Ajar / RPP / LKPD / P5:** Teruskan ke profil `kurikulum-guru`.
   - **Desain Poster / Publikasi Medsos:** Teruskan ke profil `kreator-humas`.
   - **Audio Rapat / Notula / Kanban:** Teruskan ke profil `sekretaris-rapat`.
   - **FAQ Kepegawaian / Kinerja PMM:** Teruskan ke profil `mitra-pegawai`.
   - **Proyek Besar Lintas Bidang:** Inisiasi Dekomposisi `/swarm`.

## 2. Sintaks Perutean hermes peer
Eksekusi pengiriman pesan ke agen pelaksana:
```bash
hermes peer send --to kurikulum-guru --message "Tolong buatkan draf Modul Ajar Matematika Fase D tentang Aljabar Terdiferensiasi untuk Bu Nurul."
```

## 3. Protokol QA Gatekeeper (Verifikasi Mutu Sebelum Rilis)
Sebelum menyampaikan berkas hasil ke pengguna:
1. Cek kelengkapan komponen wajib (apakah ada kop resmi, apakah diferensiasi 3 kelompok murid ada, apakah nomor surat valid).
2. Periksa ejaan bahasa Indonesia baku dan tidak adanya halusinasi format.
3. Kirimkan pesan pengantar hangat dari Dr. Fatimah disertai lampiran dokumen hasil kerja tim.
