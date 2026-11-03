---
name: sinkronisasi-github
description: "Use when syncing bot config/skills/MCP/activity to GitHub."
version: 1.0.0
author: Dr. Fatimah (pamong-utama)
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [github, git, backup, cron, otomatisasi, sinkronisasi, ops]
    related_skills: [github, hermes-agent]
---

# Sinkronisasi GitHub Harian (Backup Otomatis Bot)

Aturan tetap user: konfigurasi, skills, MCP, dan catatan kegiatan bot harus
ter-arsip ke GitHub SETIAP HARI secara otomatis. Repo: `/opt/data/fatimah-bot`
(remote `https://github.com/yudeka-eureka/fatimah-bot`, branch `main`, PUBLIC).

## When to Use

Gunakan saat: menyetel/mengubah cron sinkronisasi harian, menambah/menghapus apa yang disinkronkan, memperbaiki push yang gagal, atau menyiapkan job cron deterministik serupa (backup/otomasi).

## Kondisi Terpasang
- Skrip kanonik (dijalankan cron): `/opt/data/scripts/daily-sync.sh`.
- Salinan repo: `/opt/data/fatimah-bot/scripts/daily-sync.sh` — skrip menyalin dirinya ke sini tiap run agar versi GitHub ikut ter-update.
- Cron job Hermes: "Sinkronisasi GitHub Harian" — `no_agent`, tiap hari 16:30 UTC (= 23:30 WIB), deliver ke chat origin.
- Yang disinkronkan: persona root (SOUL/AGENTS/MEMORY/USER), 5 profil, seluruh skills, config runtime TERSARING, daftar MCP (`config/mcp_servers.md`), dan `activity/YYYY-MM-DD.md`.

## Jalankan Manual
```bash
bash /opt/data/scripts/daily-sync.sh
```

## Aturan & Pitfall (wajib)
- **Jangan pernah push nilai rahasia.** Repo ini PUBLIC — redact config runtime dulu: nilai di bawah kunci sensitif (`api_key`, `token`, `secret`, `password`, `authorization`, `client_secret`, `access_token`, dst.) diganti `${REDACTED}`, KECUALI nilainya sudah referensi `${VAR}` atau placeholder. File `.env`/kredensial tetap ter-ignore.
- **Cron berjalan `HOME=/opt/data`, terminal `HOME=/opt/data/home`.** Config git & gh (kredensial) ada di `/opt/data/home`. Skrip yang butuh `git push`/`gh` harus `export HOME=/opt/data/home` di awal (path data absolut, jadi aman). Tanpa ini push gagal "could not read Username".
- **Kredensial push HTTPS**: `gh auth setup-git`, lalu set helper di level repo `git config credential.helper "!/opt/data/home/.local/bin/gh auth git-credential"` — repo-level terbaca terlepas dari HOME.
- **Hermes cron `script` harus file nyata di `~/scripts/`** (nama relatif, TANPA symlink/traversal). Pakai `no_agent: true` untuk job deterministik tanpa biaya LLM; stdout skrip dikirim sebagai pesan (jaga tetap ringkas, pindahkan log debug ke stderr).
- **Deteksi "model aktif" & MCP dari config mudah keliru**: saat memindai `model:`, lewati model STT/TTS/embedding (`whisper-1`, `tts`, `embed`, `transcribe`, `image`, `dall`) dan placeholder (`base`, `auto`) karena muncul sebelum model LLM. Untuk MCP ambil hanya kunci indentasi-2 (nama server), bukan `headers`/`url` turunannya.
- **Idempoten**: skrip harus aman dijalankan ulang (aktivitas harian memakai nama file per tanggal; commit skip jika tidak ada perubahan).
- **Profil baru wajib ditambahkan ke daftar hardcoded.** `daily-sync.sh` menyalin profil lewat loop `for p in kreator-humas ... tata-usaha` (nama hardcoded). Saat membuat profil baru (mis. `orkestrator-wa`), tambahkan namanya ke daftar itu — kalau tidak, SOUL.md/AGENTS.md profil baru tidak ikut ter-arsip ke GitHub.
