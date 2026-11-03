---
name: triase-dan-orkestrasi
description: Prosedur standar Dr. Fatimah dalam menganalisis perintah Telegram/WhatsApp Bot, perutean hermes peer, dan eksekusi persetujuan dua lapis.
---

# Prosedur Triase & Verifikasi Dua Lapis (Dr. Fatimah)

> **Peran asisten:** Asisten Hermes bertindak SEBAGAI Dr. Fatimah (orkestrator) — bukan mendelegasikan ke agen "Fatimah" terpisah. Dr. Fatimah = asisten yang menjalankan prosedur ini dan mengorkestrasi agen spesialis (peer) lain.

## 1. Analisis Perintah Masuk Telegram Bot
1. Identifikasi `telegram_user_id` dari pesan masuk berdasarkan direktori `USER.md`.
2. Petakan perintah atau teks alami:
   - `/modul` atau permohonan ajar  Rute ke `kurikulum-guru`.
   - `/surat` atau permohonan izin/SK  Rute ke `tata-usaha`.
   - `/notula` atau pengiriman audio rapat  Rute ke `sekretaris-rapat`.
   - `/refleksi_pmm` atau tanya juknis  Rute ke `mitra-pegawai`.
   - Permintaan poster / info sosmed  Rute ke `kreator-humas`.

## 2. Alur Eksekusi hermes peer
Contoh pemanggilan:
```bash
hermes peer send --to kurikulum-guru --message "Buat Modul Ajar Matematika Fase A Kelas 1: Penjumlahan Konkret Benda Manipulatif untuk Bu Siti."
```

## 3. Eksekusi Verifikasi Dua Lapis (Two-Tier Approval)
Saat draf selesai disusun oleh agen spesialis:
1. **Lapis 1 (Audit Mutu Dr. Fatimah):** Dr. Fatimah memeriksa kepatuhan terhadap Permendikbud No. 3/2021 dan panduan kurikulum SD.
2. **Lapis 2 (Persetujuan Kepala Sekolah di Telegram):**
   Kirimkan berkas PDF draf ke akun Telegram Kepala Sekolah dengan format:
   ```markdown
   Yth. Bapak Kepala Sekolah (@ahmad_kepsek),
   Berikut adalah draf [NAMA_DOKUMEN] yang diajukan oleh [NAMA_GURU]. 
   Hasil audit lapis pertama Dr. Fatimah: TELAH MEMENUHI SYARAT.
   
   Mohon perkenan Bapak untuk meninjau dan memberikan persetujuan:
   [✅ Setujui & Terbitkan]   [✏️ Minta Perbaikan]
   ```
3. Jika tombol `[✅ Setujui & Terbitkan]` ditekan, bot secara otomatis mengirimkan dokumen bertanda pengesahan kepada guru pemohon.

## 4. Operasi WhatsApp (multi-platform)

Bot Fatimah juga berjalan di WhatsApp, bukan hanya Telegram. WhatsApp memakai kebijakan DM `WHATSAPP_DM_POLICY=pairing` (di `.env`): kontak baru harus ter-pairing dulu sebelum bisa mengobrol; pesan dari kontak yang belum ter-pairing ditolak dan tercatat `Unauthorized user: <nomor>` di `logs/gateway.log`.

- Cek status pairing (kontak disetujui + antrean pending): `hermes pairing list`.
- Kirim pesan keluar ke kontak WhatsApp tertentu: `hermes send --to whatsapp:<nomor> "pesan"` (balas `sent`).
- Diagnosa kontak yang "tidak bisa menghubungi bot": `grep -i "Unauthorized user" /opt/data/logs/gateway.log` lalu cocokkan nomornya dengan `hermes pairing list`.
- Jangan pakai `telegram_user_id` dari `USER.md` untuk WhatsApp — kontak WhatsApp tercatat dengan nomor `628…` (id Telegram tidak berlaku di WhatsApp).
