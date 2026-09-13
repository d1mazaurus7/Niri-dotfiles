import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import "theme" as Theme

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    readonly property int playerCount: Mpris.players.values.length

    readonly property var player: {
        const n = root.playerCount
        const list = Mpris.players.values
        if (!n)
            return null
        for (let i = 0; i < n; i++) {
            const p = list[i]
            if (p && p.isPlaying)
                return p
        }
        return list[0]
    }

    property real anchorPos: 0
    property real anchorMs: 0

    readonly property real pos: {
        if (!player)
            return 0
        if (!player.isPlaying)
            return player.position > 0 ? player.position : anchorPos
        const p = player.position
        if (p > 0.5)
            return p
        const dt = (Date.now() - anchorMs) / 1000
        return Math.max(0, anchorPos + dt * (player.rate || 1))
    }

    function fmt(t) {
        if (!isFinite(t) || t < 0)
            return "0:00"
        const m = Math.floor(t / 60)
        const s = Math.floor(t % 60)
        return m + ":" + String(s).padStart(2, "0")
    }

    function cycleLoop() {
        if (!player || !player.loopSupported)
            return
        if (player.loopState === MprisLoopState.None)
            player.loopState = MprisLoopState.Playlist
        else if (player.loopState === MprisLoopState.Playlist)
            player.loopState = MprisLoopState.Track
        else
            player.loopState = MprisLoopState.None
    }

    function rememberPos() {
        if (!player)
            return
        const p = player.position
        if (p > 0) {
            root.anchorPos = p
            root.anchorMs = Date.now()
        }
    }

    function playVolumeSound() {
        Quickshell.execDetached([
            "pw-play",
            `${Quickshell.shellDir}/assets/audio-volume-change.oga`
        ])
    }


    FrameAnimation {
        running: root.player !== null && root.player.playbackState === MprisPlaybackState.Playing
        onTriggered: {
            if (root.player)
                root.player.positionChanged()
        }
    }

    Connections {
        target: root.player
        function onPositionChanged() {
            root.rememberPos()
        }
        function onTrackTitleChanged() {
            root.anchorPos = 0
            root.anchorMs = Date.now()
        }
        function onIsPlayingChanged() {
            root.rememberPos()
        }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 5

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 1

            Text {
                Layout.fillWidth: true
                text: player ? (player.trackTitle || player.identity || "unknown") : "no media"
                color: Theme.Palette.text
                font.pixelSize: 14
                font.bold: true
                font.family: "JetBrains Mono Bold"
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text {
                Layout.fillWidth: true
                visible: player !== null
                text: {
                    if (!player)
                        return ""
                    const cur = root.fmt(root.pos)
                    const dur = player.length > 0 ? root.fmt(player.length) : "--:--"
                    return cur + " / " + dur
                }
                color: Theme.Palette.subtext
                font.pixelSize: 12
                font.bold: true
                font.family: "JetBrains Mono Bold"

            }
        }

        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: 2
            visible: player !== null

            PlayerBtn {
                text: player && player.loopState === MprisLoopState.Track ? "󰑘" : ""
                active: player && player.loopState !== MprisLoopState.None
                onClicked: {
                    cycleLoop()
                    playVolumeSound()
                }
            }
            PlayerBtn {
                text: ""
                onClicked: {
                    if (player && player.canGoPrevious) 
                        player.previous()
                    playVolumeSound()
                }
            }
            PlayerBtn {
                text: player && player.isPlaying ? "" : ""
                onClicked: if (player) player.togglePlaying()
            }
            PlayerBtn {
                text: ""
                onClicked: {
                    if (player && player.canGoNext) 
                        player.next()
                    playVolumeSound()
                }
            }
        }
    }

    component PlayerBtn: Rectangle {
        id: btn
        property alias text: label.text
        property bool active: false
        signal clicked

        implicitWidth: 26
        implicitHeight: 40
        radius: 6
        color: ma.containsMouse ? Theme.Palette.hover : "transparent"

        Text {
            id: label
            anchors.centerIn: parent
            color: btn.active ? Theme.Palette.accent : Theme.Palette.text
            font.pixelSize: 20
            font.bold: true
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: btn.clicked()
        }
    }
}
