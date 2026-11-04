# Configuration, Toolsets & Voice

Edit with `hermes config edit` or `hermes config set section.key value`.
Full reference: https://hermes-agent.nousresearch.com/docs/user-guide/configuration

### Config Sections (most-used keys)

| Section | Key options |
|---------|-------------|
| `model` | `default`, `provider`, `base_url`, `api_key`, `context_length`, `aliases` |
| `agent` | `max_turns` (90), `tool_use_enforcement`, `service_tier`, `verify_on_stop` |
| `terminal` | `backend` (local/docker/ssh/modal/daytona/vercel_sandbox, or a plugin backend like singularity), `cwd`, `timeout` (180) |
| `compression` | `enabled`, `threshold` (0.50), `target_ratio` (0.20) |
| `display` | `skin`, `interface` (cli/tui), `language`, `show_reasoning`, `show_cost`, `pet` |
| `approvals` | `mode` (smart/manual/off), `timeout`, `cron_mode` |
| `stt` | `enabled`, `provider` (local/groq/openai/mistral/elevenlabs/deepinfra) |
| `tts` | `provider` (edge/elevenlabs/openai/minimax/mistral/neutts/gemini/piper/kittentts/deepinfra/xai) |
| `memory` | `memory_enabled`, `user_profile_enabled`, `provider`, `write_approval` |
| `security` | `redact_secrets`, `website_blocklist` |
| `delegation` | `model`, `provider`, `max_concurrent_children`, `max_iterations` (50), `max_spawn_depth` |
| `checkpoints` | `enabled`, `max_snapshots` (50) |
| `curator` | `enabled`, `consolidate` (false, opt-in aux-model consolidation), `interval_hours`, `stale_after_days` |

`hermes config check` reports sections missing from an older config.

### Per-platform display (hide tool progress / logs)

To make a messaging platform "quiet" (no tool breadcrumbs, no "⏳ Working — N min" heartbeat, only the final answer), set keys under `display.platforms.<platform>` — e.g. WhatsApp:

```bash
hermes config set display.platforms.whatsapp.tool_progress off   # bare "off" → boolean false → normaliser maps to "off"
hermes config set display.platforms.whatsapp.long_running_notifications false
hermes config set display.platforms.whatsapp.interim_assistant_messages false
hermes config set display.platforms.whatsapp.busy_ack_detail false
hermes config set display.platforms.whatsapp.show_reasoning false
hermes config set display.platforms.whatsapp.suppress_warning_notifications true
hermes config set display.memory_notifications off   # GLOBAL (not per-platform) — silences "💾 Self-improvement review"/"Memory updated"
```

Keys: `tool_progress` (off/new/all/verbose/log), `long_running_notifications`, `interim_assistant_messages`, `busy_ack_detail`, `show_reasoning`, `suppress_warning_notifications`, `cleanup_progress`.

Pitfalls:
- `hermes config set` coerces bare `off`/`on`/`true`/`false` to booleans (YAML 1.1), BUT the gateway normaliser (`_norm_tristate` in `gateway/display_config.py`) maps boolean `False` → `"off"` and `True` → `"all"`, so for `tool_progress` bare `off` is CORRECT (`hermes config set ... tool_progress off` → `false` → `off`). Do NOT quote it: `'"off"'` stores the literal string `"off"` (with quotes), which the normaliser does not recognise and silently falls back to `all`.
- Display settings are resolved per turn from `load_user_config_effective()` (mtime-cached), so `display.platforms.<plat>.*` edits apply on the NEXT message without a gateway restart in practice. If a stale value persists, restart from a separate shell: `hermes gateway restart` is BLOCKED from inside the gateway (it would SIGTERM its own child turns).
- `memory_notifications` (the "💾 Self-improvement review"/"Memory updated" chat notice) is read GLOBALLY as `display.memory_notifications`, NOT per-platform — the `config_defaults` comment claiming `display.platforms.<platform>.memory_notifications` is misleading and that per-platform key is silently ignored. Silence it with `hermes config set display.memory_notifications off`; bare `off` is stored verbatim because the setting's default is the string `"on"`.

### Toolsets

Enable/disable via `hermes tools` (interactive) or `hermes tools enable/disable NAME`.
Full enumeration: `TOOLSETS` dict in `toolsets.py` (`_HERMES_CORE_TOOLS` is the default bundle most platforms inherit).

| Toolset | What it provides |
|---------|-----------------|
| `web` / `search` | Web search + extraction / search-only subset |
| `browser` | Browser automation (Browserbase, Camofox, or local Chromium) |
| `terminal` | Shell commands and process management |
| `file` | File read/write/search/patch |
| `code_execution` | Sandboxed Python execution |
| `coding` | Code-editing helpers (LSP-backed) |
| `computer_use` | Desktop GUI control (cua-driver) |
| `vision` | Image analysis |
| `image_gen` | Image generation and image-to-image editing |
| `video` / `video_gen` | Video analysis / video generation |
| `x_search` | X (Twitter) search (X OAuth or API key) |
| `tts` | Text-to-speech |
| `skills` | Skill browsing and management |
| `memory` | Persistent cross-session memory |
| `session_search` | Search past conversations |
| `context_engine` | Pluggable context-engine hooks |
| `project` | Named multi-folder workspace tools |
| `delegation` | Subagent task delegation |
| `cronjob` | Scheduled task management |
| `clarify` | Ask user clarifying questions |
| `todo` | In-session task planning |
| `kanban` | Multi-agent work-queue tools (gated to workers) |
| `debugging` | Extra introspection tools (off by default) |
| `safe` | Minimal low-risk toolset for locked-down sessions |
| `discord`, `discord_admin`, `feishu_doc`, `feishu_drive`, `yuanbao` | Service integrations (gated on their credentials). `homeassistant` (`ha_*` tools) and `spotify` (`spotify_*` tools) are not built in: they come from the `homeassistant` / `spotify` catalog plugins (`hermes plugins install <name>`) |

Tool changes take effect on `/reset` (new session) — never mid-conversation, to preserve prompt caching.

## Voice

### STT (Voice → Text)

Voice messages from messaging platforms are auto-transcribed.

```yaml
stt:
  enabled: true
  provider: local   # local (faster-whisper, free) | groq | openai | mistral | elevenlabs | deepinfra
  local:
    model: base     # tiny, base, small, medium, large-v3, turbo
```

Auto-detect priority: local faster-whisper (`python -c "import pm; pm.sync_venv(['stt-whisper'], explicit=True)"`) → Groq (`GROQ_API_KEY`, free tier) → OpenAI (`VOICE_TOOLS_OPENAI_KEY`) → Mistral Voxtral (`MISTRAL_API_KEY`).

### TTS (Text → Voice)

| Provider | Env var | Free? |
|----------|---------|-------|
| Edge TTS (default) | None | Yes |
| ElevenLabs | `ELEVENLABS_API_KEY` | Free tier |
| OpenAI | `VOICE_TOOLS_OPENAI_KEY` | Paid |
| MiniMax | `MINIMAX_API_KEY` | Paid |
| Mistral | `MISTRAL_API_KEY` | Paid |
| Gemini | `GOOGLE_API_KEY` | Free tier |
| NeuTTS / Piper / KittenTTS (local) | None | Free |

Voice commands: `/voice on` (voice-to-voice), `/voice tts` (always voice), `/voice off`.
