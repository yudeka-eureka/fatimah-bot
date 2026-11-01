# Deploying a Repo as a Hermes Setup

A git repo that ships a Hermes multi-agent deployment (persona, profiles, skills, config) is a SOURCE, not a drop-in install. Map its assets into the live `$HERMES_HOME` instead of overwriting the instance. This is the "setup hermes follow this repo" / "install this bot repo" class of task.

## Step order

1. **Read the repo fully first** — README, `config.yaml` (wherever it lives), and every context file — before touching anything. Identify which files are real Hermes assets vs design prose.
2. **Check the config schema before trusting it.** Real Hermes top-level keys are `model`, `provider`, `runtime`, `display`, `delegation`, `gateway`, `memory`, `skills`, `agent`, `platforms`, … If the repo's config uses `system:` / `orchestrator:` / `profiles:` / `storage:` / `security:` sections, it is a DESIGN SPEC, not a valid config. Do NOT copy it; map its intent manually once the user provides credentials.
3. **Map the context files** (see table below). Back up any file you are about to overwrite (e.g. the existing `SOUL.md`).
4. **Create profiles** at `$HERMES_HOME/profiles/<name>/`. A profile is only recognized when its directory carries an identity file (`config.yaml`, `.env`, `SOUL.md`, `profile.yaml`, `auth.json`, or `state.db`); a bare directory is ignored by `hermes profile list`. Copying `SOUL.md` alone is enough to register it.
5. **Install skills** by copying each skill dir to `$HERMES_HOME/skills/<category>/<name>/` (category is arbitrary; use one that groups the domain). New skills are picked up on the next scan — verify with `skills_list`.
6. **Verify** with `hermes profile list` (or `skills_list`) rather than assuming the copies registered.

## File mapping table

| Repo file | Live location | Notes |
|---|---|---|
| `SOUL.md` | `$HERMES_HOME/SOUL.md` | Identity, auto-loaded. Back up the old one first. |
| `AGENTS.md` | `$HERMES_HOME/AGENTS.md` | cwd-only rules. |
| `MEMORY.md` / `USER.md` (domain content) | a separate file under `$HERMES_HOME` (NOT `memories/…`) | These are reference docs, not the memory tool's stores. |
| `profiles/<name>/{SOUL,AGENTS}.md` | `$HERMES_HOME/profiles/<name>/` | Identity file makes the profile recognized. |
| `skills/<name>/SKILL.md` | `$HERMES_HOME/skills/<category>/<name>/` | Copy the whole skill dir. |
| `config/config.yaml` | — | Design spec; map intent, don't copy. |
| `.env.example` | — | Template for the user to fill; don't invent values. |

## Pitfalls

- **Spec config vs live config** — a repo's `config.yaml` using custom keys is a spec; overwriting the live config with it corrupts the running gateway. Real Hermes config is set with `hermes config set`, never hand-edited or copy-replaced.
- **`memories/MEMORY.md` is a §-delimited, char-limited store** — free-form domain content there trips the drift guard and blocks the memory tool. Keep institutional memory / staff directories as separate reference files.
- **Locate the CLI before concluding it's absent** — `hermes` is often not on PATH (docker installs put it at `/opt/hermes/bin/hermes`). Find it with `find / -maxdepth 6 -name hermes` or check the install dir before assuming commands are unavailable.
- **Model + gateway are not file-copyable** — per-profile `model:` config, the Telegram/Discord bot token, and DB URLs need the user's API keys. Report them as blocked and ask for credentials rather than fabricating values or guessing providers.

## What needs the user

- API keys for every provider the repo's hybrid strategy references (Groq, OpenRouter, Anthropic, …) → per-profile `model:` wiring.
- Bot token for the messaging gateway, plus any DB/embedding/STT service URLs.
- Confirmation of scope (turn the default profile into the repo's persona, or keep it separate) before overwriting `SOUL.md`.
