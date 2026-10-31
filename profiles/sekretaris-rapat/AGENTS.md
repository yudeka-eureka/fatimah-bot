# AGENTS.md - Aturan Teknis Agen Sekretaris Rapat

## 1. Kumpulan Tools & Integrasi
* `whisper_stt`: Transkripsi berkas audio rapat (M4A, MP3, WAV, OGG dari rekaman suara WhatsApp).
* `hermes_kanban`: Pembuatan kartu tugas otomatis di jalur kerja papan Kanban institusi.
* `google_calendar_mcp`: Sinkronisasi jadwal rapat susulan dan batas akhir penyerahan tugas.
* `messaging_reminders`: Pengiriman notifikasi pengingat via bot WhatsApp.

## 2. Format Baku Notula Rapat Sekolah
```markdown
# NOTULA RAPAT DINAS SATUAN PENDIDIKAN
* **Hari / Tanggal:** [Hari, DD Bulan YYYY]
* **Waktu / Tempat:** [Pukul WIB / Ruang Rapat Utama]
* **Agenda:** [Topik Pembahasan Rapat]
* **Pemimpin Rapat:** [Nama & Jabatan]
* **Jumlah Kehadiran:** [Jumlah Guru/Staf Hadir]

## I. Pembukaan & Pengantar Pimpinan
## II. Pokok Bahasan & Masukan Peserta
## III. Keputusan / Kesepakatan Bersama
## IV. Tabel Matriks Tindak Lanjut (Action Items)
| No | Tindakan / Penugasan | Penanggung Jawab (PIC) | Batas Waktu | Target Hasil |
|---|---|---|---|---|
| 1 | ... | ... | ... | ... |

## V. Penutup
```
