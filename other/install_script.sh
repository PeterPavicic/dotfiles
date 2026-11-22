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
  uwsm hyprland hyprpolkitagent hypridle hyprlock hyprpaper hyprpicker hyprshot hyprshutdown xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

  # mango
  uwsm mangowm xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk grim slurp satty swaybg hyprlock hypridle hyprpicker polkit-gnome

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
  breeze breeze-gtk breeze-icons nwg-look

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
cat >"$dotfiles/.git/hooks/post-merge" <<'EOF'
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

# AUR packages are not installed automatically (their PKGBUILDs should be reviewed
# first): missing ones and pending AUR updates are added to the manual steps at the end.
aur_packages=(
  claude-code
  downgrade
  hyprqt6engine
  nestopia
  nordvpn-bin
  plymouth-theme-arch-charge-big
  teams-for-linux-bin
  teams-for-linux-wayland-hook
  wayfreeze
  yay
  zoom
)

check_aur_packages() {
  local pkg updates err_file
  local missing=()

  # pacman -Q also accepts a package that provides the name (e.g. yay-bin for yay)
  for pkg in "${aur_packages[@]}"; do
    pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
  done

  if ((${#missing[@]})); then
    add_msg "Install AUR packages: yay -S ${missing[*]}"
  fi

  # Checks every installed AUR package, not just the list above (yay -Sua updates them all).
  # yay exits 1 both when nothing is outdated and when the AUR can't be reached;
  # only the latter writes to stderr.
  err_file=$(mktemp)
  if updates=$(yay -Qua -q 2>"$err_file"); then
    add_msg "Update AUR packages (${updates//$'\n'/, }): yay -Sua"
  elif [[ -s $err_file ]]; then
    add_msg "Couldn't check for AUR updates: run yay -Qua"
  fi
  rm -f "$err_file"
}

check_aur_packages

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
    uv pip install -p "$nvim_venv" pynvim jupyter_client cairosvg pnglatex plotly kaleido pyperclip nbformat pillow; then
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
systemctl --user disable "${hypr_units[@]}" # drop links from earlier runs
systemctl --user add-wants wayland-session-xdg-autostart@hyprland.desktop.target "${hypr_units[@]}"
# No hyprpaper or hyprpolkitagent under Mango: both abort there (hyprpaper: hyprtoolkit
# asks for layer-shell v5, Mango offers v4; hyprpolkitagent: "Couldn't open a gbm fd").
# swaybg.service and polkit-gnome-agent.service below replace them.
systemctl --user add-wants wayland-session-xdg-autostart@mango.desktop.target hypridle.service

# mako: start it with Hyprland and Mango, hooked in like the hypr* units above.
# Not with plain `enable`: Plasma also reaches graphical-session.target, and its
# plasmashell is the notification server there, so mako would race it for
# org.freedesktop.Notifications. Starting mako with the session (not on the first
# notification) also matters once plasma-workspace is installed: it ships a second
# D-Bus service file for that name, and which of the two D-Bus activates is undefined.
systemctl --user disable mako.service # drop links from earlier runs
systemctl --user add-wants wayland-session-xdg-autostart@hyprland.desktop.target mako.service
systemctl --user add-wants wayland-session-xdg-autostart@mango.desktop.target mako.service

# The three units below are enabled for every graphical session and skip
# themselves (ExecCondition) where the session brings its own: Plasma always,
# Hyprland for the wallpaper and the polkit agent. The unit files live in this repo;
# `enable` with a path symlinks them into ~/.config/systemd/user/ and enables them.

# Clipboard history; skipped under Plasma (plasmashell keeps its own).
systemctl --user enable "$dotfiles/other/systemd/user/cliphist.service"

# Wallpaper; skipped under Hyprland (hyprpaper, hooked in above) and Plasma.
systemctl --user enable "$dotfiles/other/systemd/user/swaybg.service"

# Polkit agent; skipped under Hyprland (hyprpolkitagent, hooked in above) and
# Plasma (polkit-kde-agent).
systemctl --user enable "$dotfiles/other/systemd/user/polkit-gnome-agent.service"

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

if ((${#post_install_msgs[@]})); then
  printf '\nManual steps remaining:\n'
  printf '  - %s\n' "${post_install_msgs[@]}"
  echo "It is recommended to reboot now if installing for the first time"
fi
