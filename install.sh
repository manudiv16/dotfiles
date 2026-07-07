#!/bin/bash
# install.sh — One-shot dotfiles installer
# Usage: curl -fsSL https://raw.githubusercontent.com/manudiv16/dotfiles/main/install.sh | sh

set -euo pipefail

REPO_URL="https://github.com/manudiv16/dotfiles.git"
REPO_DEST="$HOME/dotfiles"
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# ── helpers ──────────────────────────────────────────────────────────
info()  { printf "\r[📦] %s\n" "$*"; }
ok()    { printf "\r[✅] %s\n" "$*"; }
warn()  { printf "\r[⚠️] %s\n" "$*"; }
err()   { printf "\r[❌] %s\n" "$*"; exit 1; }

# ── 1. Xcode Command Line Tools ─────────────────────────────────────
info "Checking Xcode Command Line Tools…"
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools…"
  xcode-select --install
  warn "⚠️  Follow the dialog to install Xcode CLT, then re-run this script."
  exit 1
fi
ok "Xcode CLT found"

# ── 2. Homebrew ──────────────────────────────────────────────────────
info "Checking Homebrew…"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew…"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$BREW_URL")"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "Homebrew found ($(brew --version | head -1))"

# ── 3. Clone dotfiles ────────────────────────────────────────────────
info "Checking dotfiles repo…"
if [[ -d "$REPO_DEST" ]]; then
  if [[ -d "$REPO_DEST/.git" ]]; then
    info "Updating existing dotfiles repo…"
    git -C "$REPO_DEST" pull --ff-only
  else
    warn "⚠️  $REPO_DEST exists but is not a git repo — skipping clone."
  fi
else
  info "Cloning dotfiles repo…"
  git clone "$REPO_URL" "$REPO_DEST"
fi
ok "Dotfiles ready at $REPO_DEST"

cd "$REPO_DEST"

# ── 4. Brew bundle ───────────────────────────────────────────────────
info "Installing Homebrew packages (this will take a while)…"
brew bundle --file=Brewfile --no-lock || warn "⚠️  Some brew packages failed (may need manual retry)"
ok "Homebrew packages installed"

# ── 5. Symlink configs ───────────────────────────────────────────────
info "Symlinking dotfiles…"
bash bootstrap.sh
ok "Configs symlinked"

# ── 6. Post-install notes ────────────────────────────────────────────
cat << 'EOF'

╔══════════════════════════════════════════════════════════════╗
║                    🎉  ALL DONE!                            ║
║                                                              ║
║  Restart your shell to apply configs:                        ║
║    exec zsh                                                  ║
║                                                              ║
║  Then complete the manual steps from the README:             ║
║    cat ~/dotfiles/README.md                                  ║
║                                                              ║
║  Quick reminders:                                            ║
║    • gh auth login              (GitHub)                     ║
║    • aws sso login --profile x  (AWS)                        ║
║    • colima start               (Docker)                     ║
║    • Copy ~/.ssh, ~/.gnupg,     (secrets)                    ║
║      ~/.password-store,                                     ║
║      ~/.kube/config.k3s-homelab                             ║
╚══════════════════════════════════════════════════════════════╝
EOF
