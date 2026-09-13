import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import QtQuick
import "theme" as Theme

Scope {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: !!sink?.audio
    readonly property real vol: ready ? Math.max(0, Math.min(1, sink.audio.volume)) : 0
    readonly property int percent: Math.round(vol * 100)

    property bool shown: false
    property bool armed: false

    Timer {
        interval: 400
        running: true
        onTriggered: root.armed = true
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.shown = false
    }

    function ping() {
        if (!root.armed)
            return
        root.shown = true
        hideTimer.restart()
    }

    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged() {
            root.ping()
        }
    }

    PanelWindow {
        id: win
        visible: root.shown || pill.opacity > 0
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "volume_pill"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors.left: true
        anchors.right: true
        anchors.bottom: true
        implicitHeight: 90

        mask: Region {}

        Rectangle {
            id: pill
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 48
            width: 300
            height: 36
            radius: 18
            color: Theme.Palette.surface_container
            opacity: root.shown ? 1 : 0

            readonly property real pad: 4
            readonly property real knobSize: height - pad * 2

            Behavior on opacity {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }

            Rectangle {
                id: fill
                x: pill.pad
                y: pill.pad
                height: pill.knobSize
                width: Math.max(height, knob.x + knob.width - x)
                radius: height / 2
                color: Theme.Palette.primary
            }

            Rectangle {
                id: knob
                y: pill.pad
                x: pill.pad + (pill.width - pill.pad * 2 - width) * root.vol
                width: pill.knobSize
                height: pill.knobSize
                radius: width / 2
                color: Qt.darker(Theme.Palette.primary, 1.45)

                Behavior on x {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: root.percent
                    color: Theme.Palette.surface_container
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
    }
}
