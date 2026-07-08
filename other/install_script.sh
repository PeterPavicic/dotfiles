#!/bin/sh
set -exuo pipefail

# TODO: Cleanup

# terminal
sudo pacman -S ghostty neovim luajit luarocks tmux --needed

# fonts
sudo pacman -S ttf-firacode-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --needed

# essentials
sudo pacman -S man tar curl which htop openssh rsync git base-devel networkmanager fzf --needed

# nicer essentials
sudo pacman -S bat lsd btop fd ripgrep zsh --needed

# zsh setup
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions --needed

# hyprland
sudo pacman -S hyprland hyprpolkitagent hypridle hyprlock hyprpaper hyprpicker hyprshot hyprshutdown xdg-desktop-portal-hyprland --needed

# hyprland programs
sudo pacman -S waybar blueman pavucontrol mako rofi rofi-calc rofi-emoji --needed

# neovim/tmux
sudo pacman -S tree-sitter tree-sitter-cli fd ripgrep npm --needed

# utilities
sudo pacman -S less tailscale fastfetch wl-clipboard cliphist reflector power-profiles-daemon --needed

# audio
sudo pacman -S pipewire wireplumber pipewire-pulse pipewire-alsa --needed

# file management (thunar specific)
sudo pacman -S ntfs-3g ntfsprogs gvfs-mtp ffmpegthumbnailer --needed

# cli utities
sudo pacman -S pacman-contrib pdfgrep pandoc tealdeer wev fx jq --needed

# programming
sudo pacman -S python r rust cargo uv --needed

# theme
sudo pacman -S breeze-gtk breeze-cursors breeze-icons nwg-look --needed

# programs
sudo pacman -S zathura zathura-pdf-mupdf firefox chromium thunar firewalld firewall-config --needed loupe libreoffice-fresh

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

sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now sddm.service
sudo systemctl enable --now firewalld
sudo systemctl enable --now tailscaled
sudo systemctl enable --now sshd
sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now reflector.timer

sudo systemctl edit --stdin reflector.timer <<'EOF'
[Timer]
OnBootSec=5min
RandomizedDelaySec=0
EOF

sudo cp "$HOME/dotfiles/other/etc/xdg/reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"

# enable user services
systemctl --user enable --now pipewire.service
systemctl --user enable --now wireplumber.service
systemctl --user enable --now hyprpaper.service
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpolkitagent.service

# gtk theme
gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-theme 'breeze-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "It is recommended to reboot now if installing for the first time"
