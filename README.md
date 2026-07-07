# 🚀 manudiv16 Dotfiles

Personal dotfiles and macOS migration bootstrap.

## 📋 Apps Installation Checklist

### 1. Prerequisites (before anything else)

```bash
# Xcode Command Line Tools
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. One-shot install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/manudiv16/dotfiles/main/install.sh | sh
```

### 3. Or step by step

```bash
cd ~ && git clone git@github.com:manudiv16/dotfiles.git
cd dotfiles
    
# Install everything from Brewfile
brew bundle --file=Brewfile
    
# Run bootstrap to symlink configs
./bootstrap.sh
```

### 3. Post-install manual steps

- [ ] **Authenticate GitHub CLI**: `gh auth login`
- [ ] **Authenticate AWS SSO**: `aws sso login --profile <profile>` (first time)
- [ ] **Configure pass (password-store)**: Clone or init `~/.password-store`
- [ ] **Import GPG keys**: If you have existing keys
- [ ] **SSH keys**: Copy `~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub` from backup
- [ ] **Kube configs**: Copy `~/.kube/config.k3s-homelab` from backup
- [ ] **Sync Bitwarden**: Sign in to Bitwarden
- [ ] **Zed**: Sign in to sync settings
- [ ] **Raycast**: Sign in to sync config
- [ ] **Log in to macOS App Store** and download: (Spotify)
- [ ] **DBeaver**: Set up database connections
- [ ] **Browser**: Sign in to sync bookmarks/passwords
- [ ] **Rust**: `rustup-init` (if not installed via brew)

### 4. System Settings (macOS)

- [ ] Enable FileVault (if not already)
- [ ] Enable Firewall (System Settings → Network → Firewall)
- [ ] Set keyboard repeat rate to max
- [ ] Configure Mission Control (hot corners, expose)
- [ ] Install SF Pro / SF Mono fonts (already in Brewfile)
- [ ] AeroSpace should auto-start at login

### 5. Verify everything

```bash
# Check Brewfile was fully satisfied
brew bundle check

# Test git
git --version

# Test AWS
aws --version

# Test k8s
kubectl version --client

# Test docker
colima start
docker ps

# Test terminal
echo "All good 🎉"
```

---

## 🔐 Secrets Audit Report

### ✅ Fixed During Migration

| File | Issue | Action Taken |
|------|-------|-------------|
| `~/.zshenv` | `JIRA_API_TOKEN` in plain text | **REMOVED** — token was hardcoded, now deleted. Re-add via password manager if needed. |

### ⚠️ Items to Handle Manually (Not in this repo)

| Location | What | Recommendation |
| ---------- | ------ | --------------- |
| `~/.docker/config.json` | ECR auth tokens (AWS), GHCR token, Docker Hub token | These auto-refresh; will be re-created after `aws sso login` + `docker login`. Safe to leave. |
| `~/.ssh/id_ed25519` | SSH private key | **DO NOT COMMIT**. Copy manually to new laptop. |
| `~/.gnupg/private-keys-v1.d/` | GPG private keys | **DO NOT COMMIT**. Copy manually. |
| `~/.password-store/` | All passwords | **DO NOT COMMIT**. Copy manually. |
| `~/.aws/cli/cache/` | STS session tokens | Auto-refresh, skip copy. |
| `~/.kube/*` | K8s cluster tokens | kubeconfigs use `assume` + `aws eks get-token`; no static tokens. Safe to copy config only. |
| `~/.config/gh/hosts.yml` | GitHub auth tokens | Auto-created by `gh auth login`. |

### ✅ Already Safe

| Location | Why |
| ---------- | ----- |
| `~/.aws/config` | SSO-based, no hardcoded keys |
| `~/.kube/config*` | Uses `assume` credential process, no static tokens |
| `~/.config/gh/config.yml` | No tokens stored in config |
| Dotfiles repo | No secrets, tokens, or passwords |

---

## 📦 What's in this repo

| Path | Description |
| ------ | ------------- |
| `.gitconfig` | Git aliases and config |
| `.gitignore` | Global gitignore |
| `.zshenv` | Zsh env vars (env vars only, no secrets) |
| `.zshrc` | Zsh config: aliases, completions, plugins |
| `.zprofile` | Zsh login shell config, brew shellenv |
| `.aerospace.toml` | AeroSpace tiling WM config |
| `.config/wezterm/wezterm.lua` | WezTerm terminal config |
| `.config/sketchybar/` | SketchyBar menu bar config |
| `.config/borders/` | Borders config for window decorations |
| `Brewfile` | All Homebrew packages, casks, and apps |
| `bootstrap.sh` | Symlink setup script |

## 🛠 Bootstrap Script

```bash
cd ~/dotfiles
./bootstrap.sh
```

This will symlink all config files to their expected locations.

---

## 📝 Migration notes

- **macOS version**: 26.5 (Sequoia)
- **Shell**: zsh (default)
- **Terminal**: WezTerm
- **Window manager**: AeroSpace
- **Menu bar**: SketchyBar
- **Launcher**: Raycast
- **Secrets**: pass (password-store) + Bitwarden
- **Browser**: Zen
