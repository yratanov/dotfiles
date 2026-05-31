// Audio source picker — vim-navigable menu listing all PipeWire input and
// output devices. Toggle via `quickshell ipc call audio toggle`, bound to
// SUPER+SHIFT+A in dot-config/hypr/bindings.conf.
//
// Keys:
//   h / l (or ←/→): switch Output ↔ Input pane
//   j / k (or ↓/↑): move within device list
//   Space / Enter:  set highlighted device as default
//   Esc / q:        close
// Click outside or on a device row also works.

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire

Scope {
    id: root

    property bool open: false
    property string side: "output"       // "output" | "input"
    property int outputIndex: 0
    property int inputIndex: 0

    // IPC entry point — `quickshell ipc call audio <toggle|show|hide>`.
    IpcHandler {
        target: "audio"
        function toggle(): void { root.setOpen(!root.open) }
        function show(): void   { root.setOpen(true) }
        function hide(): void   { root.setOpen(false) }
    }

    function setOpen(v) {
        if (v && !root.open) syncIndexes()   // start highlight on current default
        root.open = v
    }

    function syncIndexes() {
        const o = outputs.indexOf(Pipewire.defaultAudioSink)
        const i = inputs.indexOf(Pipewire.defaultAudioSource)
        if (o >= 0) outputIndex = o
        if (i >= 0) inputIndex  = i
    }

    // Real audio devices only — exclude per-app stream nodes.
    readonly property var outputs: Pipewire.nodes.values.filter(n =>
        n && n.isSink && !n.isStream && n.audio)
    readonly property var inputs: Pipewire.nodes.values.filter(n =>
        n && !n.isSink && !n.isStream && n.audio)

    // Keep every visible node's `.audio` sub-object subscribed; otherwise their
    // volume/muted bindings would go stale.
    PwObjectTracker {
        objects: [...root.outputs, ...root.inputs]
    }

    readonly property var devices: side === "output" ? outputs : inputs
    readonly property int index: side === "output" ? outputIndex : inputIndex

    function setIndex(v) {
        const n = devices.length
        if (n === 0) return
        const clamped = Math.max(0, Math.min(n - 1, v))
        if (side === "output") outputIndex = clamped
        else                   inputIndex  = clamped
    }

    function setSide(s) {
        side = s
        // Clamp index in case the other list is shorter.
        const n = devices.length
        if (n > 0 && index >= n) setIndex(n - 1)
    }

    function pick() {
        if (devices.length === 0) return
        const node = devices[index]
        if (side === "output") Pipewire.preferredDefaultAudioSink   = node
        else                   Pipewire.preferredDefaultAudioSource = node
    }

    // Click-outside dismiss via Hyprland focus grab.
    HyprlandFocusGrab {
        active: root.open && panelLoader.item !== null
        windows: panelLoader.item ? [panelLoader.item] : []
        onCleared: root.open = false
    }

    // Only spawn the menu surface when actually open.
    LazyLoader {
        id: panelLoader
        active: root.open

        PanelWindow {
            id: panel
            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
            color: "#88000000"      // dim backdrop
            exclusiveZone: 0
            focusable: true

            // Click on the dim area (outside the card) closes.
            MouseArea {
                anchors.fill: parent
                onClicked: root.open = false
            }

            Rectangle {
                id: card
                anchors.centerIn: parent
                width: 680
                height: 460
                radius: 12
                color: "#f21e2326"
                border.color: "#3c474d"
                border.width: 1

                // Block backdrop clicks from leaking through the card.
                MouseArea { anchors.fill: parent }

                // Focused item for keystrokes.
                Item {
                    id: keys
                    anchors.fill: parent
                    focus: true
                    Component.onCompleted: forceActiveFocus()
                    Keys.onPressed: (e) => {
                        switch (e.key) {
                        case Qt.Key_Escape:
                        case Qt.Key_Q:
                            root.open = false; e.accepted = true; break
                        case Qt.Key_J:
                        case Qt.Key_Down:
                            root.setIndex(root.index + 1); e.accepted = true; break
                        case Qt.Key_K:
                        case Qt.Key_Up:
                            root.setIndex(root.index - 1); e.accepted = true; break
                        case Qt.Key_L:
                        case Qt.Key_Right:
                            root.setSide("input"); e.accepted = true; break
                        case Qt.Key_H:
                        case Qt.Key_Left:
                            root.setSide("output"); e.accepted = true; break
                        case Qt.Key_Tab:
                            root.setSide(root.side === "output" ? "input" : "output")
                            e.accepted = true; break
                        case Qt.Key_Space:
                        case Qt.Key_Return:
                        case Qt.Key_Enter:
                            root.pick(); e.accepted = true; break
                        }
                    }

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        // ── Header ───────────────────────────────────────────
                        Text {
                            text: "Audio devices"
                            color: "#d3c6aa"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        // ── Two-column body ──────────────────────────────────
                        Row {
                            width: parent.width
                            height: parent.height - 70   // leave room for footer
                            spacing: 16

                            // Left: type selector
                            Column {
                                id: typeCol
                                width: 150
                                spacing: 4
                                Repeater {
                                    model: [
                                        { key: "output", label: "Output", icon: "󰕾" },
                                        { key: "input",  label: "Input",  icon: "󰍬" },
                                    ]
                                    delegate: Rectangle {
                                        required property var modelData
                                        readonly property bool active: root.side === modelData.key
                                        width: typeCol.width
                                        height: 44
                                        radius: 8
                                        color:        active ? "#a7c08022" : "transparent"
                                        border.color: active ? "#a7c080"   : "transparent"
                                        border.width: 1
                                        Row {
                                            anchors.left: parent.left
                                            anchors.leftMargin: 12
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 10
                                            Text {
                                                text: modelData.icon
                                                color: "#d3c6aa"
                                                font.family: "JetBrainsMono Nerd Font Mono"
                                                font.pixelSize: 18
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Text {
                                                text: modelData.label
                                                color: "#d3c6aa"
                                                font.family: "JetBrainsMono Nerd Font Mono"
                                                font.pixelSize: 14
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.setSide(modelData.key)
                                        }
                                    }
                                }
                            }

                            // Divider
                            Rectangle {
                                width: 1
                                height: parent.height
                                color: "#3c474d"
                            }

                            // Right: device list
                            Column {
                                id: devCol
                                width: parent.width - typeCol.width - 17 - 16
                                spacing: 6

                                Repeater {
                                    model: root.devices
                                    delegate: Rectangle {
                                        id: row
                                        required property var modelData
                                        required property int index
                                        readonly property bool selected: index === root.index
                                        readonly property bool isDefault:
                                            (root.side === "output" && Pipewire.defaultAudioSink   === modelData) ||
                                            (root.side === "input"  && Pipewire.defaultAudioSource === modelData)
                                        readonly property real vol:   modelData.audio ? modelData.audio.volume : 0
                                        readonly property bool muted: modelData.audio ? modelData.audio.muted  : false
                                        readonly property string label:
                                            modelData.description || modelData.nickname || modelData.name

                                        // Live audio peak (0..1), updated by `pw-peak` helper while menu is open.
                                        // Holds the last reported value and decays steadily so the bar falls
                                        // smoothly when audio stops instead of snapping to zero.
                                        property real peakHold: 0
                                        Process {
                                            running: root.open
                                            command: ["pw-peak", String(modelData.name)]
                                            stdout: SplitParser {
                                                onRead: (line) => {
                                                    const v = parseFloat(line)
                                                    if (!isNaN(v) && v > row.peakHold) row.peakHold = v
                                                }
                                            }
                                        }
                                        Timer {
                                            interval: 50
                                            repeat: true
                                            running: root.open
                                            onTriggered: row.peakHold = Math.max(0, row.peakHold - 0.06)
                                        }

                                        width: devCol.width
                                        height: 58
                                        radius: 8
                                        color:        selected ? "#a7c08022" : "transparent"
                                        border.color: selected ? "#a7c080"   : "transparent"
                                        border.width: 1

                                        Column {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            anchors.rightMargin: 12
                                            anchors.topMargin: 8
                                            anchors.bottomMargin: 8
                                            spacing: 6

                                            Row {
                                                width: parent.width
                                                spacing: 8
                                                Text {
                                                    text: row.isDefault ? "●" : "○"
                                                    color: row.isDefault ? "#a7c080" : "#7a8478"
                                                    font.pixelSize: 12
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                                Text {
                                                    width: parent.width - 18 - 64
                                                    elide: Text.ElideRight
                                                    text: row.label
                                                    color: "#d3c6aa"
                                                    font.family: "JetBrainsMono Nerd Font Mono"
                                                    font.pixelSize: 13
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                                Text {
                                                    width: 56
                                                    horizontalAlignment: Text.AlignRight
                                                    text: row.muted ? "muted" : Math.round(row.vol * 100) + "%"
                                                    color: row.muted ? "#e67e80" : "#9da9a0"
                                                    font.family: "JetBrainsMono Nerd Font Mono"
                                                    font.pixelSize: 12
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                            }

                                            // Volume bar.
                                            // - Background : track.
                                            // - Dim fill   : the device's *volume setting* (where the slider is).
                                            // - Bright fill: live audio peak from `pw-peak`, decays smoothly.
                                            Rectangle {
                                                width: parent.width
                                                height: 5
                                                radius: 2
                                                color: "#3c474d"
                                                Rectangle {
                                                    width: parent.width * Math.min(1, Math.max(0, row.vol))
                                                    height: parent.height
                                                    radius: parent.radius
                                                    color: row.muted     ? "#7a8478"
                                                         : row.vol > 1.0 ? "#e67e80"
                                                         :                 "#5a7050"   // dim green
                                                    Behavior on width { NumberAnimation { duration: 120 } }
                                                }
                                                Rectangle {
                                                    width: parent.width * Math.min(1, row.peakHold)
                                                    height: parent.height
                                                    radius: parent.radius
                                                    color: row.muted ? "transparent"
                                                                     : "#a7c080"        // bright green
                                                    opacity: row.muted ? 0 : 1
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: { root.setIndex(row.index); root.pick() }
                                        }
                                    }
                                }

                                Text {
                                    visible: root.devices.length === 0
                                    text: "No " + (root.side === "output" ? "outputs" : "inputs") + " available"
                                    color: "#7a8478"
                                    font.family: "JetBrainsMono Nerd Font Mono"
                                    font.pixelSize: 12
                                }
                            }
                        }

                        // ── Footer (keybind hint) ────────────────────────────
                        Text {
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: "h/l switch · j/k move · space pick · esc close"
                            color: "#7a8478"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }
}
