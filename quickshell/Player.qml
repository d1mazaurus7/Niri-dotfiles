import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import "theme" as Theme

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    readonly property var player: {
        const list = Mpris.players.values
        if (!list || list.length === 0)
            return null
        for (let i = 0; i < list.length; i++)
            if (list[i].playbackState === MprisPlaybackState.Playing)
                return list[i]
        return list[0]
    }

    property real pos: 0

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

    Timer {
        interval: 500
        running: player !== null
        repeat: true
        onTriggered: {
            if (player)
                root.pos = player.position
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
            }
        }

        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: 2
            visible: player !== null

            PlayerBtn {
                text: player && player.loopState === MprisLoopState.Track ? "󰑘" : ""
                active: player && player.loopState !== MprisLoopState.None
                onClicked: cycleLoop()
            }
            PlayerBtn {
                text: ""
                onClicked: if (player && player.canGoPrevious) player.previous()
            }
            PlayerBtn {
                text: player && player.isPlaying ? "" : ""
                onClicked: if (player) player.togglePlaying()
            }
            PlayerBtn {
                text: ""
                onClicked: if (player && player.canGoNext) player.next()
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
