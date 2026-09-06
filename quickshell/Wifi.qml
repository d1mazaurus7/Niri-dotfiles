import Quickshell
import Quickshell.Io
import QtQuick
import "theme" as Theme

Rectangle {
    id: root

    implicitWidth: content.implicitWidth + 16
    implicitHeight: content.implicitHeight + 8
    radius: 20
    color: Theme.Palette.surface_container

    property int fontSize: 13
    property string netIcon: "󰤮"
    property string netLabel: "offline"

    Process {
        id: netProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = (text || "").trim().split("\n").filter(l => l.length)
                let wifi = ""
                let eth = ""

                for (const line of lines) {
                    const parts = line.split(":")
                    const type = parts[0]
                    const state = parts[1]
                    const conn = parts.slice(2).join(":")
                    if (state !== "connected")
                        continue
                    if (type === "wifi")
                        wifi = conn
                }

                if (wifi) {
                    root.netIcon = "󰖩"
                    root.netLabel = wifi
                }
                else {
                    root.netIcon = "󰖪"
                    root.netLabel = "offline"
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            netProc.running = false
            netProc.running = true
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: root.netIcon
            color: Theme.Palette.on_surface
            font.pixelSize: root.fontSize
            font.family: "Symbols Nerd Font"
        }
        Text {
            text: root.netLabel
            color: Theme.Palette.on_surface
            font.pixelSize: root.fontSize
            font.bold: true
        }
    }
}
