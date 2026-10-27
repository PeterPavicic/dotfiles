#!/bin/sh
set -exuo pipefail

# terminal
sudo pacman -S kitty neovim luajit luarocks tmux --needed

# fonts
sudo pacman -S ttf-firacode-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --needed

# essentials
sudo pacman -S man tar curl zip unzip which htop openssh rsync git base-devel networkmanager fzf --needed

# nicer essentials
sudo pacman -S bat lsd btop fd ripgrep zsh --needed

# zsh setup
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions --needed

# hyprland
sudo pacman -S hyprland hyprpolkitagent hypridle hyprlock hyprpaper hyprpicker hyprshot hyprshutdown xdg-desktop-portal-hyprland --needed

# hyprland programs
sudo pacman -S waybar blueman pavucontrol mako rofi rofi-calc rofi-emoji --needed

# neovim/tmux
sudo pacman -S tree-sitter tree-sitter-cli fd ripgrep npm imagemagick --needed

# utilities
sudo pacman -S less tailscale fastfetch wl-clipboard cliphist reflector power-profiles-daemon bluez-obex --needed

# audio
sudo pacman -S pipewire wireplumber pipewire-pulse pipewire-alsa --needed

# file management (thunar specific)
sudo pacman -S ntfs-3g ntfsprogs gvfs-mtp ffmpegthumbnailer --needed

# cli utities
sudo pacman -S pacman-contrib pdfgrep pandoc tealdeer wev fx jq xh --needed

# programming
sudo pacman -S python r rust cargo uv --needed

# theme
sudo pacman -S breeze-gtk breeze-icons nwg-look --needed

# programs
sudo pacman -S zathura zathura-pdf-mupdf firefox chromium thunar firewalld firewall-config loupe libreoffice-fresh qbittorrent --needed

# docker
sudo pacman -S podman podman-compose podman-docker buildah skopeo 

POST_INSTALL_MSGS=""

add_msg() {
  POST_INSTALL_MSGS="${POST_INSTALL_MSGS}  - $1
"
}

# set up temporary ssh-key
if [ ! -e "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "temp_ssh_key" -f ~/.ssh/id_ed25519
  echo "Created ed25519 ssh key."
  cat ~/.ssh/id_ed25519.pub
  add_msg "Configure ssh keys"
fi

# pull dotfiles
if [ ! -d "$HOME/dotfiles/" ]; then
  mkdir -p "$HOME/dotfiles/"
  git -c url."https://github.com/".insteadOf="git@github.com:" clone --recurse-submodules git@github.com/PeterPavicic/dotfiles.git "$HOME/dotfiles"
  sh "$HOME/dotfiles/create_symlinks.sh"

  cd "$HOME/dotfiles/"

  # Add post-merge hook to script which creates symlinks
  cat > .git/hooks/post-merge << 'EOF'
#!/bin/sh
"$(git rev-parse --show-toplevel)/create_symlinks.sh"
EOF

  chmod +x .git/hooks/post-merge

  cd "$HOME"
fi

# Install yay if not installed
if ! command -v yay >/dev/null 2>&1; then
  mkdir -p "$HOME/yay/"
  git clone https://aur.archlinux.org/yay.git "$HOME/yay"
  cd "$HOME/yay"
  makepkg -si
  cd "$HOME"
  rm -rf "$HOME/yay"
fi

# install TPM if missing
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  mkdir -p "$HOME/.tmux/plugins/tpm"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  add_msg "Installed TPM. Open tmux and press C-b + I now"
fi


# sets up neovim's python provider if it doesn't exist yet
setup_nvim_python_host() {
  nvim_venv="$HOME/.local/share/nvim/python-host"

  if [ -x "$nvim_venv/bin/python" ]; then
      echo "nvim python host already present at $nvim_venv, skipping"
      return 0
  fi

  echo "Creating nvim python host at $nvim_venv"
  mkdir -p "$(dirname "$nvim_venv")" || return 1

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


# Initialise reflector config
sudo cp "$HOME/dotfiles/other/etc/xdg/reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"

# enable system services
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now sddm.service
sudo systemctl enable --now firewalld
sudo systemctl enable --now tailscaled
sudo systemctl enable --now sshd
sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now reflector.service
sudo systemctl enable --now reflector.timer

sudo systemctl edit --stdin reflector.timer <<'EOF'
[Timer]
OnBootSec=5min
RandomizedDelaySec=0
EOF

# enable user services
systemctl --user enable --now pipewire.service
systemctl --user enable --now wireplumber.service
systemctl --user enable --now hyprpaper.service
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now obex.service

# cursors
install_cursor_theme() {
  theme=$1
  icons_dir="$HOME/.local/share/icons"
  archive="$HOME/dotfiles/other/$theme.tar.xz"
  
  if [ -d "$icons_dir/$theme" ]; then
      echo "$theme already installed, skipping"
      return 0
  fi
  
  mkdir -p "$icons_dir" || return 1

  if tar -xJf "$archive" -C "$icons_dir"; then
      echo "Installed $theme"
  else
      echo "Extracting $theme failed, removing partial install" >&2
      rm -rf "$icons_dir/$theme"
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
[ -n "$login_shell" ] || login_shell=$SHELL

case "$login_shell" in
  */zsh) ;;
  *) add_msg 'Set zsh as your login shell: chsh -s "$(command -v zsh)"' ;;
esac

if [ -n "$POST_INSTALL_MSGS" ]; then
    printf '\nManual steps remaining:\n%s' "$POST_INSTALL_MSGS"
    echo "It is recommended to reboot now if installing for the first time"
fi
