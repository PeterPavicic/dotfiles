# Mango setup (next to Hyprland, managed by uwsm)

Goal: try [Mango](https://mangowm.github.io/) as a second uwsm-managed session
next to Hyprland, reusing these dotfiles. Hyprland stays as it is; you pick the
session on the SDDM login screen.

## Already prepared

- `install_script.sh` hooks `hypridle`, `hyprpaper` and `hyprpolkitagent` into
  `wayland-session-xdg-autostart@mango.desktop.target`, so they start only in Mango's uwsm
  session (and in Hyprland's).
- `cliphist.service` (`other/systemd/user/`) runs in every graphical session.
- `~/.config/hypr/dpms.sh`, which hypridle uses to turn screens off and on, has a
  Mango branch using `mmsg`. **It is untested**, see step 5.
- uwsm env: `~/.config/uwsm/env` and `env.d/` apply to Mango too. Mango-only
  variables go in `~/.config/uwsm/env-mango`. Mango's desktop names are
  `mango;wlroots`, so `env-wlroots` is loaded as well if it exists.

## 1. Install

```sh
sudo pacman -S mangowm
```

## 2. Add a uwsm session entry

The package only ships `mango.desktop`, which starts Mango without uwsm. SDDM
also reads `/usr/local/share/wayland-sessions/`, so add a uwsm entry there:

```sh
sudo install -d /usr/local/share/wayland-sessions
sudo tee /usr/local/share/wayland-sessions/mango-uwsm.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Mango (uwsm-managed)
Comment=mango WM, managed by uwsm
Exec=uwsm start -e -D mango:wlroots mango.desktop
TryExec=uwsm
DesktopNames=mango;wlroots
Type=Application
EOF
```

`uwsm start … mango.desktop` makes `mango.desktop` the session ID. That is where
the `wayland-session-xdg-autostart@mango.desktop.target` name used by the install script
comes from.

## 3. Start a config inside the dotfiles

Start from the default config shipped with the package, and keep it in the repo:

```sh
mkdir -p ~/dotfiles/home/.config/mango
cp /etc/mango/config.conf ~/dotfiles/home/.config/mango/config.conf
~/dotfiles/create_symlinks.sh                 # links ~/.config/mango
mango -c ~/.config/mango/config.conf -p       # validate without starting Mango
```

## 4. Minimal uwsm changes to the default config

Get a working session first, then port the rest (step 6).

- **Launching programs:** bindings look like `bind=MODS,KEY,spawn,COMMAND`.
  Prefix programs with `uwsm-app --` so each runs in its own systemd unit:
  `bind=SUPER,Return,spawn,uwsm-app -- kitty`.
  rofi needs no prefix: `~/.config/rofi/config.rasi` already wraps what it launches.
  Use `spawn_shell` instead of `spawn` when the command has a pipe.
- **Exit:** the default config has `bind=SUPER,m,quit`. That is Mango's own exit,
  which uwsm says not to use. Remove it, or replace it with
  `bind=SUPER,m,spawn,uwsm stop`. The rofi power menu's log out also works.
- **Autostart:** the default config starts nothing. Add
  `exec_once=uwsm-app -- waybar -c ~/.config/waybar/mango.jsonc`.
  `exec_once=` runs once at startup; `exec=` runs again on every reload. Both
  run through `sh -c`, so `~` and `$HOME` work.
- **Environment variables:** put them in `~/.config/uwsm/env-mango`, not in
  Mango's `env=` lines (those are reset on every config reload).
- **`uwsm finalize` is not needed:** Mango exports `WAYLAND_DISPLAY`,
  `MANGO_INSTANCE_SIGNATURE` and friends to systemd by itself.

## 5. First login checks

Log in with **Mango (uwsm-managed)**, open a terminal and run:

```sh
echo "$XDG_CURRENT_DESKTOP"                                  # contains "mango"
systemctl --user status wayland-wm@mango.desktop.service     # CGroup: only mango (+ Xwayland), no apps
systemctl --user is-active hypridle hyprpaper hyprpolkitagent cliphist
~/.config/hypr/dpms.sh off; sleep 5; ~/.config/hypr/dpms.sh on   # tests dpms.sh's Mango branch
```

If something doesn't start: `journalctl --user -b -u <service>`.

Mango also starts its own `mango-session.target`. If startup or logout acts up
under uwsm, look there first.

## 6. Port the Hyprland-only pieces

- **waybar:** already split. Each compositor starts its own file with `-c`:
  `waybar/hyprland.jsonc` and `waybar/mango.jsonc`. Both include
  `waybar/common.jsonc` for the shared modules. `mango.jsonc` uses waybar's
  `mango/workspaces` and `mango/language` modules (waybar 0.16+). They use the
  same CSS ids as the Hyprland modules, so `style.css` is shared.
- **Keyboard layout switching:** `hypr/switchLayout.sh` uses `hyprctl`, so
  clicking the language module does nothing under Mango yet.
- **Screenshots:** `hyprshot` needs Hyprland; use `grim` + `slurp`.
- **The rest of `hypr/lua/`:** port input, monitors, bindings and window rules in
  small steps. Mango uses dwl-style tags instead of workspaces (a window can carry
  several tags). Check early whether there is anything like Hyprland's tabbed
  groups (`auto_group`, groupbar), since those are not in Mango's docs.

## Undo

```sh
sudo rm /usr/local/share/wayland-sessions/mango-uwsm.desktop
rm -r ~/.config/systemd/user/wayland-session-xdg-autostart@mango.desktop.target.wants
sudo pacman -Rns mangowm
```
