// Entry point. Each component is a separate QML file in this directory.
// Hot reload on save: edit any file, save, Quickshell rebuilds the scene.

import QtQuick
import Quickshell

Scope {
    AudioOsd  {}     // volume + mic-mute OSD pill
    AudioMenu {}     // SUPER+SHIFT+A — vim-navigable audio device picker
}
