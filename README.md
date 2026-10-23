# rudy-commit

Offline commit message generator for bash. It reads your staged changes, asks a local LLM ([Ollama](https://ollama.com)) for a message, and returns it in [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) format, in English:

```
feat: add user login endpoint

- Add POST /login handler in src/api/auth.js that validates credentials
  against the users table and returns a signed JWT token
- Add tests for the login flow
```

Your code is never sent anywhere. Everything runs on your machine.

## Installation

1. Install Ollama: https://ollama.com/download (internet is only needed for this step and the next one)
2. Download a model:
   ```bash
   ollama pull llama3.2:3b          # default model (~2 GB)
   # ollama pull qwen2.5-coder:7b   # better at code, heavier (~4.7 GB); use with -m or RUDY_MODEL
   ```
3. Install the command:
   ```bash
   bash install.sh
   source ~/.bashrc
   ```

## Usage

```bash
git add .
commit dis
```

While the model thinks you see a loader (`𓃉𓃉∘ Generating... 4s`). Then the command shows the suggested message and asks you what to do:

| Key | Action |
|-----|--------|
| `c` / Enter | Commit with that message |
| `e` | Open it in your git editor, then commit |
| `r` | Generate it again (you can give the model a hint) |
| `q` | Quit without committing |

### Options

| Flag | Description |
|------|-------------|
| `-a` | Run `git add -A` before generating |
| `-y` | Commit without asking |
| `-p` | Only print the message (for example `commit dis -p > msg.txt`) |
| `-m <model>` | Use a different Ollama model |
| `-t <type>` | Force the type (`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`) |
| `-h "<hint>"` | Give the model extra context, e.g. `-h "fixes #42"` |

### Environment variables

- `RUDY_MODEL`: default model (`llama3.2:3b`)
- `RUDY_MAX_DIFF`: maximum number of diff characters sent to the model (`8000`, sized for the 3B model's context window)
- `RUDY_NO_ANIM`: set it to any value to turn off the loading animation (`RUDY_NO_ANIM=1 commit dis`)

## Notes

- `commit dis` is a bash function named `commit` that `install.sh` adds to `~/.bashrc`. Running `commit` without `dis` just prints the usage. You can also call `rudy-commit` directly, and re-running `install.sh` updates the shortcut in place.
- Lockfiles and minified files are left out of the diff the model sees, which keeps the prompt short.
- If the first line the model returns doesn't follow the format, the command retries once automatically.
- The Ollama app or service has to be running. On Windows it starts with the system after you install it.
