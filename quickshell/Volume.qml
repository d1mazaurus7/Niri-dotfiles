import Quickshell
import QtQuick
import "theme" as Theme
import Quickshell.Services.Pipewire

Rectangle {
    id: root
    implicitWidth: content.implicitWidth + 16
    implicitHeight: content.implicitHeight + 8
    radius: 20
    color: Theme.Palette.surface_container

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: !!sink?.audio
    readonly property bool muted: ready && sink.audio.muted
    readonly property int percent: ready ? Math.round(sink.audio.volume * 100) : 0
    readonly property string icon: {
        if (!ready || muted || percent == 0)
            return ""
        if (percent < 20)
            return ""
        if (percent < 40)
            return ""
        if (percent < 70)
            return ""
        return ""
    }

    property bool soundArmed: false
    property bool soundCooling: false

    function playVolumeSound() {
        Quickshell.execDetached([
            "pw-play",
            `${Quickshell.shellDir}/assets/audio-volume-change.oga`
        ])
    }

    function notifyVolumeSound() {
        if (!soundArmed || soundCooling)
            return
        soundCooling = true
        playVolumeSound()
        cool.restart()
    }

    Timer {
        interval: 400
        running: true
        repeat: false
        onTriggered: root.soundArmed = true
    }

    Timer {
        id: cool
        interval: 90
        onTriggered: root.soundCooling = false
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: root.icon
            color: Theme.Palette.on_surface
            font.pixelSize: 13
            font.family: "JetBrains Mono Bold"
        }

        Text {
            text: root.ready ? (root.percent + "%") : "--%"
            font.bold: true
            font.family: "JetBrains Mono Bold"
            color: Theme.Palette.on_surface
        }
    }

    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged() {
            root.notifyVolumeSound()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (root.ready)
                root.sink.audio.muted = !root.sink.audio.muted
        }
        onWheel: (w) => {
            if (!root.ready)
                return
            const step = 0.05
            const next = root.sink.audio.volume + (w.angleDelta.y > 0 ? step : -step)
            root.sink.audio.volume = Math.max(0, Math.min(1, next))
            w.accepted = true
        }
    }
}
