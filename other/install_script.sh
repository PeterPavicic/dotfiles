#!/bin/sh
set -exuo pipefail

# TODO: Cleanup

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

# set up temporary ssh-key
if [ ! -e "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "temp_ssh_key" -f ~/.ssh/id_ed25519
  echo "Created ed25519 ssh key."
  cat ~/.ssh/id_ed25519.pub
fi

# pull dotfiles
if [ ! -d "$HOME/dotfiles/" ]; then
  mkdir -p "$HOME/dotfiles/"
  git -c url."https://github.com/".insteadOf="git@github.com:" clone --recurse-submodules git@github.com/PeterPavicic/dotfiles.git "$HOME/dotfiles"
  sh "$HOME/dotfiles/create_symlinks.sh"

  cd "$HOME/dotfiles/"

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
  # TODO: Edit so this is added to messages at the end of script
  echo "Installed TPM. Open tmux and press C-b + I now"
fi

# TODO: incorporate:
# chsh -s "$(command -v zsh)"

# enable system services

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

echo "It is recommended to reboot now if installing for the first time"
