# Zenity App to Adjust Screen Brightness
For certain computers, Screen Brightness settings may be missing.
If screen brightness can be adjusted using `xrandr`, this zenity app presents a user-friendly interface to adjust the screen brightness using `xrandr` commands.

## Installation
For system-wide installation:
1. Copy `brightness.sh` (0777) and `brightness.ico` (0644) to `/opt/brightness/` (0755).
2. Copy `brightness.desktop` (0644) to `/usr/share/applications/`.

For user-only installation:
1. Copy `brightness.sh` (0777) and `brightness.ico` (0644) to `~/.local/brightness/` (0755).
2. Copy `brightness.desktop` (0644) to `/~/.local/share/applications`, and edit the file to correct the path of `Exec` and `Icon`.

## Usage
On complete installation, the brightness app should show up in the application trays; double-click to launch.
