# Agent instructions

`AGENTS.md` contains shared default instructions for coding agents across repositories.

Install with:

```bash
./install config/agents/dotbot
```

The installer links the same source file to these locations:

| Harness | Instruction file |
| --- | --- |
| Shared location | `~/.config/agents/AGENTS.md` |
| Codex | `~/.codex/AGENTS.md` |
| [Claude Code](https://code.claude.com/docs/en/memory) | `~/.claude/CLAUDE.md` |
| [Mistral Vibe](https://docs.mistral.ai/vibe/code/cli/agents) | `~/.vibe/AGENTS.md` |

The installer warns and skips existing files, directories, and symlinks using
`symlinkfb --no-clobber`. Links already pointing to the shared file are left
unchanged without a warning. Other missing instruction files are still installed.
These are the default harness locations; custom configuration homes need their
own symlinks. For other harnesses, link their instruction file to the shared
file or configure them to read it.

The security instructions refer to an environment-provided rules bundle via
`codex_install_path`; that bundle is not installed by this configuration.
