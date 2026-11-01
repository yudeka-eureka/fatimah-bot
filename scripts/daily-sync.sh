#!/usr/bin/env bash
# ============================================================================
# daily-sync.sh — Sinkronisasi harian Fatimah Bot ke GitHub
# ----------------------------------------------------------------------------
# Mengarsipkan ke repo git (SECRET-FREE):
#   1) Persona root (SOUL.md, AGENTS.md, MEMORY.md, USER.md)
#   2) Profil agen (SOUL.md + AGENTS.md tiap profil)
#   3) Skills (SKILL.md + references/templates/assets)
#   4) Konfigurasi runtime TERSARING (nilai rahasia di-redact)
#   5) Daftar MCP servers (dengan kredensial di-redact)
#   6) Catatan kegiatan harian (activity/YYYY-MM-DD.md)
# lalu commit + push.
#
# Dipanggil oleh cron harian. Idempoten & aman dijalankan ulang.
# ============================================================================
set -euo pipefail

# Kredensial git & gh tinggal di /opt/data/home; cron gateway berjalan dengan
# HOME=/opt/data sehingga git/gh tidak menemukan configs-nya. Paksa HOME yang
# benar agar push terotentikasi (semua path data memakai absolut, jadi aman).
export HOME="/opt/data/home"

REPO="/opt/data/fatimah-bot"
DATA="/opt/data"
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE=$(date -u +"%Y-%m-%d")
WIB=$(TZ=Asia/Jakarta date +"%Y-%m-%d %H:%M WIB")

cd "$REPO"

# --- 0. Arsipkan skrip ini sendiri agar salinan repo ikut ter-update --------
# (canonical untuk cron ada di /opt/data/scripts/daily-sync.sh)
cp -f /opt/data/scripts/daily-sync.sh "$REPO/scripts/daily-sync.sh" 2>/dev/null || true

# --- 1. Persona root -------------------------------------------------------
for f in SOUL.md AGENTS.md MEMORY.md USER.md; do
  if [ -f "$DATA/$f" ]; then
    cp -f "$DATA/$f" "$REPO/$f"
  fi
done

# --- 2. Profil agen --------------------------------------------------------
for p in kreator-humas kurikulum-guru mitra-pegawai sekretaris-rapat tata-usaha; do
  mkdir -p "$REPO/profiles/$p"
  for f in SOUL.md AGENTS.md; do
    if [ -f "$DATA/profiles/$p/$f" ]; then
      cp -f "$DATA/profiles/$p/$f" "$REPO/profiles/$p/$f"
    fi
  done
done

# --- 3. Skills -------------------------------------------------------------
rm -rf "$REPO/skills"
mkdir -p "$REPO/skills"
# salin SKILL.md + berkas pendukung (references/templates/assets), lewati cache/lock
find "$DATA/skills" -type f \
  \( -name 'SKILL.md' \
     -o -path '*/references/*' \
     -o -path '*/templates/*' \
     -o -path '*/assets/*' \) \
  ! -path '*/.locks/*' ! -name '*.lock' ! -name '*.jsonl' ! -name '.usage.json' \
  | while read -r f; do
      rel="${f#"$DATA/skills/"}"
      mkdir -p "$REPO/skills/$(dirname "$rel")"
      cp -f "$f" "$REPO/skills/$rel"
    done

# --- 4 + 5. Redact konfigurasi runtime + MCP -------------------------------
mkdir -p "$REPO/config"
python3 - "$DATA/config.yaml" "$REPO/config" <<'PY'
import re, sys, os
src, outdir = sys.argv[1], sys.argv[2]

SENSITIVE = re.compile(
    r'(api[_-]?key|apikey|token|secret|password|passwd|authorization|bearer|'
    r'client[_-]?secret|client[_-]?id|private[_-]?key|access[_-]?token|'
    r'refresh[_-]?token|credential|telegram[_-]?token|bot[_-]?token)',
    re.IGNORECASE)

def redact_value(v):
    v = v.strip()
    # sudah aman: kosong / referensi env / placeholder => biarkan
    if v == '' or '${' in v or v in ('"your-key-here"', "'your-key-here'",
                                     '"<REDACTED>"', 'your-key-here'):
        return v
    return '${REDACTED}'

def redact_line(line):
    # komentar dibiarkan
    if line.lstrip().startswith('#'):
        return line
    m = re.match(r'^(\s*)([A-Za-z0-9_\-\.]+)(\s*:\s*)(.*)$', line)
    if m:
        indent, key, sep, val = m.groups()
        if SENSITIVE.search(key):
            return f"{indent}{key}{sep}{redact_value(val)}"
    return line

lines = open(src, encoding='utf-8', errors='ignore').read().splitlines()
out = []
for ln in lines:
    out.append(redact_line(ln))

with open(os.path.join(outdir, 'config.runtime.yaml'), 'w', encoding='utf-8') as f:
    f.write('# GENERATED — konfigurasi runtime tersaring (nilai rahasia di-redact otomatis)\n')
    f.write('# Sumber: ~/config.yaml (Fatimah Bot). JANGAN sertakan nilai rahasia di sini.\n')
    f.write('\n'.join(out) + '\n')

# ekstrak blok mcp_servers (aktif) untuk ringkasan terpisah
text = '\n'.join(out)
mcp = []
in_mcp = False
for ln in text.splitlines():
    if re.match(r'^mcp_servers\s*:', ln):
        in_mcp = True
        mcp.append(ln)
        continue
    if in_mcp:
        if re.match(r'^\S', ln) and not ln.startswith((' ', '\t')):
            break
        mcp.append(ln)
summary = '# MCP Servers (terhubung)\n\n'
summary += '\n'.join(mcp) if mcp else '(tidak ada blok mcp_servers aktif)'
summary += '\n'
with open(os.path.join(outdir, 'mcp_servers.md'), 'w', encoding='utf-8') as f:
    f.write(summary)
print('redact+mcpsummary ok', file=sys.stderr)
PY

# --- 6. Catatan kegiatan harian --------------------------------------------
mkdir -p "$REPO/activity"
python3 - "$REPO" "$DATE" "$STAMP" "$WIB" <<'PY'
import sys, os, subprocess, re
repo, date, stamp, wib = sys.argv[1:6]

def sh(cmd):
    try:
        return subprocess.run(cmd, shell=True, capture_output=True, text=True,
                              cwd=repo).stdout.strip()
    except Exception:
        return ''

# perubahan working tree vs HEAD (sebelum commit)
diffstat = sh('git diff --stat HEAD -- .') or '(tidak ada perubahan)'
untracked = sh('git ls-files --others --exclude-standard | head -50')

# hitung skills & profil
skills = []
for root, dirs, files in os.walk(os.path.join(repo, 'skills')):
    if 'SKILL.md' in files:
        rel = os.path.relpath(os.path.join(root, 'SKILL.md'), os.path.join(repo, 'skills'))
        skills.append(rel.replace('/SKILL.md', ''))
skills_sorted = sorted(skills)
profiles = sorted(d for d in os.listdir(os.path.join(repo, 'profiles'))
                  if os.path.isdir(os.path.join(repo, 'profiles', d)))

# mcp servers (hanya nama server tingkat-1: indentasi 2 spasi)
mcp = []
try:
    for ln in open(os.path.join(repo, 'config', 'mcp_servers.md'), encoding='utf-8'):
        m = re.match(r'^  ([A-Za-z0-9_\-]+)\s*:', ln)
        if m:
            mcp.append(m.group(1))
except Exception:
    pass

# model aktif (lewati komentar & nilai placeholder seperti 'base'/'auto')
model = ''
try:
    for ln in open(os.path.join(repo, 'config', 'config.runtime.yaml'), encoding='utf-8'):
        if ln.lstrip().startswith('#'):
            continue
        m = re.match(r'^\s+model\s*:\s*"?([^"#\n]+?)"?\s*(?:#.*)?$', ln)
        if m:
            cand = m.group(1).strip()
            low = cand.lower()
            is_placeholder = low in ('base', 'auto', '')
            is_non_llm = any(k in low for k in
                             ('whisper', 'tts', 'embed', 'transcribe', 'image', 'dall'))
            if cand and not is_placeholder and not is_non_llm:
                model = cand
                break
except Exception:
    pass

# riwayat commit terakhir
recent = sh('git log -5 --oneline')

body = f"""# Catatan Kegiatan Harian — {date}

**Waktu sinkronisasi (WIB):** {wib}
**Timestamp (UTC):** {stamp}

## Ringkasan Perubahan Berkas (vs HEAD)
```
{diffstat}
```

## Berkas Baru (untracked)
```
{untracked or '(tidak ada)'}
```

## Status Sistem Saat Ini
- **Model aktif:** {model or '(tidak terdeteksi)'}
- **MCP servers:** {', '.join(mcp) if mcp else '(kosong)'}
- **Jumlah skills:** {len(skills_sorted)}
- **Profil agen:** {', '.join(profiles)}

## Daftar Skills
{chr(10).join('- ' + s for s in skills_sorted) or '(kosong)'}

## Riwayat Commit Terakhir
```
{recent}
```
"""
path = os.path.join(repo, 'activity', f'{date}.md')
with open(path, 'w', encoding='utf-8') as f:
    f.write(body)
print('activity log:', path, file=sys.stderr)
PY

# --- 7. Commit & push ------------------------------------------------------
git add -A
SHA=""
if git diff --cached --quiet; then
  echo "Tidak ada perubahan — repositori sudah sinkron."
else
  git -c user.name="Fatimah" -c user.email="fatimah.62.education@gmail.com" \
      commit -m "chore(daily): auto-sync konfigurasi, skills, MCP & kegiatan ($DATE)" >/dev/null
  SHA=$(git rev-parse --short HEAD)
fi
git push origin main >/dev/null 2>&1
if [ -n "$SHA" ]; then
  echo "Sinkronisasi GitHub harian selesai — commit ${SHA} ter-push ke main."
else
  echo "Repositori GitHub sudah sinkron (tidak ada perubahan)."
fi
