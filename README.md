# Desktop Menu

A Plasma 6 panel widget that brings a macOS Finder-style menu to the desktop. Place it next to the Global Menu: it appears only when no application window is focused, and hides as soon as an app takes focus.

![Desktop Menu open on the desktop](screenshots/menu.png)

![Full desktop with Desktop Menu in the top panel](screenshots/desktop.png)

## Menus

- **File** — new Dolphin window, new terminal (Konsole), new text file (KWrite), search (KRunner)
- **View** — Overview, Show Desktop, take a screenshot (Spectacle), About
- **Go** — Home, Desktop, Documents, Downloads, Pictures, Computer, Trash
- **System** — System Settings, System Monitor, Lock, Log Out, Restart, Shut Down

## Requirements

Plasma 6. The default menu entries use Dolphin, Konsole, KWrite, Spectacle and Plasma System Monitor.

## Install

```sh
kpackagetool6 -t Plasma/Applet -i .
```

Then add **Desktop Menu** to the panel that holds the Global Menu, right after it.

For development, symlink the repo instead so edits are picked up after `plasmashell --replace`:

```sh
ln -s "$PWD" ~/.local/share/plasma/plasmoids/local.desktopmenu
```

## Customizing

Edit the `menus` list in `contents/ui/main.qml`. Each entry is `[label, icon, shell command]`; `null` inserts a separator.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE).
