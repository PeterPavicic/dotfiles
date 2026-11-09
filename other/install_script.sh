#!/usr/bin/env bash
set -euxo pipefail

dotfiles="$HOME/dotfiles"

packages=(
  # terminal
  kitty neovim luajit tmux

  # fonts
  ttf-firacode-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

  # essentials
  man tar curl zip unzip which htop openssh rsync git base-devel networkmanager fzf

  # nicer essentials
  bat lsd btop fd ripgrep zsh

  # zsh setup
  zsh-syntax-highlighting zsh-autosuggestions

  # display manager
  sddm

  # hyprland
  # (to try Mango next to Hyprland, follow other/MANGO-SETUP.md after this script)
  uwsm hyprland hyprpolkitagent hypridle hyprlock hyprpaper hyprpicker hyprshot hyprshutdown xdg-desktop-portal-hyprland

  # hyprland programs
  waybar blueman pavucontrol mako rofi rofi-calc rofi-emoji

  # neovim/tmux
  tree-sitter tree-sitter-cli fd ripgrep npm imagemagick

  # utilities
  less tailscale fastfetch wl-clipboard cliphist reflector power-profiles-daemon bluez-obex strace

  # audio
  pipewire wireplumber pipewire-pulse pipewire-alsa

  # file management (thunar specific)
  ntfs-3g ntfsprogs gvfs-mtp ffmpegthumbnailer

  # cli utities
  pacman-contrib pdfgrep pandoc tealdeer wev fx jq xh

  # programming
  python r rust cargo uv

  # theme
  breeze-gtk breeze-icons nwg-look

  # programs
  zathura zathura-pdf-mupdf firefox chromium thunar firewalld firewall-config loupe libreoffice-fresh qbittorrent

  # docker
  podman podman-compose podman-docker buildah skopeo
)

sudo pacman -S --needed "${packages[@]}"

post_install_msgs=()

add_msg() {
  post_install_msgs+=("$1")
}

# set up temporary ssh-key
if [[ ! -e $HOME/.ssh/id_ed25519 ]]; then
  ssh-keygen -t ed25519 -C "temp_ssh_key" -f "$HOME/.ssh/id_ed25519"
  echo "Created ed25519 ssh key."
  cat "$HOME/.ssh/id_ed25519.pub"
  add_msg "Configure ssh keys"
fi

# pull dotfiles (skipped when this script is run from an existing clone)
if [[ ! -d $dotfiles ]]; then
  git -c url."https://github.com/".insteadOf="git@github.com:" clone --recurse-submodules git@github.com:PeterPavicic/dotfiles.git "$dotfiles"
fi

# Symlink dotfiles into $HOME. Runs even if the clone above was skipped;
# safe to rerun, existing symlinks are left alone.
"$dotfiles/create_symlinks.sh"

# Recreate symlinks after every `git pull` so newly added files get linked.
# Commits made locally don't trigger this hook: rerun create_symlinks.sh after adding files.
cat > "$dotfiles/.git/hooks/post-merge" << 'EOF'
#!/usr/bin/env bash
"$(git rev-parse --show-toplevel)/create_symlinks.sh"
EOF
chmod +x "$dotfiles/.git/hooks/post-merge"

# Install yay if not installed
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git "$HOME/yay"
  (cd "$HOME/yay" && makepkg -si)
  rm -rf "$HOME/yay"
fi

# install TPM if missing
if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  add_msg "Installed TPM. Open tmux and press C-b + I now"
fi


# sets up neovim's python provider if it doesn't exist yet
setup_nvim_python_host() {
  local nvim_venv="$HOME/.local/share/nvim/python-host"

  if [[ -x $nvim_venv/bin/python ]]; then
    echo "nvim python host already present at $nvim_venv, skipping"
    return 0
  fi

  echo "Creating nvim python host at $nvim_venv"
  mkdir -p "${nvim_venv%/*}"

  # If jupyter has never been run "properly", this won't exist
  echo "Creating jupyter runtime path"
  mkdir -p "$HOME/.local/share/jupyter/runtime"

  if uv venv --python python3 "$nvim_venv" &&
     uv pip install -p "$nvim_venv" pynvim jupyter_client cairosvg pnglatex plotly kaleido pyperclip nbformat pillow
  then
    echo "nvim python host ready"
  else
    echo "nvim python host setup failed, removing partial venv" >&2
    rm -rf "$nvim_venv"
    return 1
  fi
}

setup_nvim_python_host


# enable system services
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now sddm.service
sudo systemctl enable --now firewalld
sudo systemctl enable --now tailscaled
sudo systemctl enable --now sshd
sudo systemctl enable --now power-profiles-daemon.service


# Initialise reflector config
sudo cp "$dotfiles/other/etc/xdg/reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"
# Run once
sudo systemctl start reflector.service

# reflector: run only via timer, 5min after boot, to avoid delays
sudo systemctl edit --stdin reflector.timer <<'EOF'
[Timer]
OnBootSec=5min
RandomizedDelaySec=0
EOF
sudo systemctl disable reflector.service
sudo systemctl enable --now reflector.timer

# enable user services
systemctl --user enable --now pipewire.service
systemctl --user enable --now wireplumber.service
systemctl --user enable --now obex.service

# hypr* session services: start them only with the compositors listed here
# (plain `enable` would hook them into graphical-session.target, i.e. every compositor).
# Hook them into wayland-session-xdg-autostart@, NOT wayland-session@: a target is
# ordered after what it wants, the units are ordered after graphical-session.target,
# and that is ordered after wayland-session@, so systemd would drop them as a cycle.
# mango.desktop only matters once Mango is set up, see other/MANGO-SETUP.md
# (harmless before that: the target is never started)
hypr_units=(hyprpaper.service hypridle.service hyprpolkitagent.service)
systemctl --user disable "${hypr_units[@]}"   # drop links from earlier runs
for session in hyprland.desktop mango.desktop; do
  systemctl --user add-wants "wayland-session-xdg-autostart@$session.target" "${hypr_units[@]}"
done

# Clipboard history for every graphical session. The unit file lives in this repo;
# `enable` with a path symlinks it into ~/.config/systemd/user/ and enables it.
systemctl --user enable "$dotfiles/other/systemd/user/cliphist.service"

# cursors
install_cursor_theme() {
  local theme=$1
  local icons_dir="$HOME/.local/share/icons"
  local archive="$dotfiles/other/$theme.tar.xz"

  if [[ -d $icons_dir/$theme ]]; then
    echo "$theme already installed, skipping"
    return 0
  fi

  mkdir -p "$icons_dir"

  if tar -xJf "$archive" -C "$icons_dir"; then
    echo "Installed $theme"
  else
    echo "Extracting $theme failed, removing partial install" >&2
    rm -rf "${icons_dir:?}/$theme"
    return 1
  fi
}

install_cursor_theme Bibata-Modern-Classic-hyprcursor
install_cursor_theme Bibata-Modern-Classic-xcursor

# gtk theme
gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic-xcursor'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# check whether zsh is the login shell
login_shell=$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7)
login_shell=${login_shell:-$SHELL}

if [[ $login_shell != */zsh ]]; then
  add_msg 'Set zsh as your login shell: chsh -s "$(command -v zsh)"'
fi

if (( ${#post_install_msgs[@]} )); then
  printf '\nManual steps remaining:\n'
  printf '  - %s\n' "${post_install_msgs[@]}"
  echo "It is recommended to reboot now if installing for the first time"
fi
