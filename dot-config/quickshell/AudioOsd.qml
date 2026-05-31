// OSD pill — flashes top-center on volume / mute / mic-mute change.
// Triggered by Pipewire property signals; volume keys themselves are bound to
// `wpctl` in dot-config/hypr/bindings.conf.

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Scope {
    id: root

    PwObjectTracker {
        objects: {
            const list = []
            if (Pipewire.defaultAudioSink)   list.push(Pipewire.defaultAudioSink)
            if (Pipewire.defaultAudioSource) list.push(Pipewire.defaultAudioSource)
            return list
        }
    }

    readonly property var  sink:   Pipewire.defaultAudioSink
    readonly property var  source: Pipewire.defaultAudioSource
    readonly property real volume:      sink   && sink.audio   ? sink.audio.volume   : 0
    readonly property bool sinkMuted:   sink   && sink.audio   ? sink.audio.muted    : false
    readonly property bool sourceMuted: source && source.audio ? source.audio.muted  : false

    // Suppress the initial flash on shell startup.
    property bool primed: false
    Component.onCompleted: Qt.callLater(() => primed = true)

    property bool   osdVisible: false
    property string mode: "volume"   // "volume" | "mic"

    onVolumeChanged:      if (primed) { mode = "volume"; flash() }
    onSinkMutedChanged:   if (primed) { mode = "volume"; flash() }
    onSourceMutedChanged: if (primed) { mode = "mic";    flash() }

    function flash() {
        osdVisible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.osdVisible = false
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: root.osdVisible

            anchors.top: true
            margins.top: 60
            implicitWidth: 360
            implicitHeight: 56
            color: "transparent"
            exclusiveZone: 0

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: "#ee1e2326"
                border.color: "#3c474d"
                border.width: 1

                // ── Volume view ─────────────────────────────────────────────
                Row {
                    id: volRow
                    visible: root.mode === "volume"
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 14

                    Text {
                        id: volIcon
                        anchors.verticalCenter: parent.verticalCenter
                        width: 24
                        horizontalAlignment: Text.AlignHCenter
                        text: root.sinkMuted     ? "󰝟"
                            : root.volume > 0.66 ? "󰕾"
                            : root.volume > 0.0  ? "󰖀"
                            :                       "󰕿"
                        color: "#d3c6aa"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 22
                    }

                    Rectangle {
                        id: volBarBg
                        anchors.verticalCenter: parent.verticalCenter
                        width: volRow.width - volIcon.width - volPct.width - 2 * volRow.spacing
                        height: 8
                        radius: 4
                        color: "#3c474d"

                        Rectangle {
                            width: parent.width * Math.min(1, Math.max(0, root.volume))
                            height: parent.height
                            radius: parent.radius
                            color: root.sinkMuted    ? "#7a8478"
                                 : root.volume > 1.0 ? "#e67e80"
                                 :                     "#a7c080"
                            Behavior on width { NumberAnimation { duration: 120 } }
                            Behavior on color { ColorAnimation  { duration: 120 } }
                        }
                    }

                    Text {
                        id: volPct
                        anchors.verticalCenter: parent.verticalCenter
                        width: 48
                        horizontalAlignment: Text.AlignRight
                        text: Math.round(root.volume * 100) + "%"
                        color: "#d3c6aa"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 14
                    }
                }

                // ── Mic view ────────────────────────────────────────────────
                Row {
                    visible: root.mode === "mic"
                    anchors.centerIn: parent
                    spacing: 14

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.sourceMuted ? "󰍭" : "󰍬"
                        color: "#d3c6aa"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 22
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.sourceMuted ? "Microphone muted" : "Microphone unmuted"
                        color: root.sourceMuted ? "#e67e80" : "#a7c080"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
}
