import QtQuick
import Quickshell
import Quickshell.Io
import "theme" as Theme

Rectangle {
    id: root
    radius: 18
    implicitWidth: content.implicitWidth + 32
    implicitHeight: content.implicitHeight + 8
    color: Theme.Palette.surface_container

    property string btDevice: "—"
    property string deviceMacAdress: "—"
    property string volLevel: "—"
    property string hpBatText: "—"
    property int hpBatLevel: -1
    property int volumeTicks: 0

    Process {
        id: connectedProc
        running: false
        command: ["bluetoothctl", "devices", "Connected"]
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = text.trim()
                // Device AA:BB:... Name With Spaces
                const m = raw.match(/Device\s+([0-9A-Fa-f:]{17})\s+(.*)/)

                if (!m) {
                    root.btDevice = "Disconnected"
                    root.deviceMacAdress = "—"
                    root.hpBatLevel = -1
                    root.hpBatText = "—"
                    return
                }

                root.deviceMacAdress = m[1]
                root.btDevice = m[2].trim() || "Disconnected"

                infoProc.command = ["bluetoothctl", "info", m[1]]
                infoProc.running = false
                infoProc.running = true
            }
        }
    }

    Process {
        id: infoProc
        running: false
        command: ["bluetoothctl", "info", "00:00:00:00:00:00"]
        stdout: StdioCollector {
            onStreamFinished: {
                const info = text

                if (!info || !/Connected:\s*yes/i.test(info)) {
                    root.hpBatLevel = -1
                    root.hpBatText = "—"
                    return
                }

                let m = info.match(/Battery Percentage:.*\((\d+)\)/i)
                if (!m)
                    m = info.match(/Battery Percentage:\s*(\d+)/i)

                if (!m) {
                    root.hpBatLevel = -1
                    root.hpBatText = "n/a"
                    return
                }

                const level = parseInt(m[1], 10)
                if (isNaN(level) || level < 0 || level > 100) {
                    root.hpBatLevel = -1
                    root.hpBatText = "—"
                    return
                }

                root.hpBatLevel = level
                root.hpBatText = level + "%"
            }
        }
    }

    Process {
        id: volumeProc
        running: false
        command: [
            "sh", "-c",
            "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{ v=int($2*100); if ($0 ~ /MUTED/) print \"Muted\"; else print v \"%\" }'"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim()
                root.volLevel = t.length ? t : "—"
            }
        }
    }

    function refreshBt() {
        connectedProc.running = false
        connectedProc.running = true
    }

    function refreshVolume() {
        volumeProc.running = false
        volumeProc.running = true
    }

    Timer {
        id: btTimer
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshBt()
    }

    Timer {
        id: volumeTimer
        interval: 200
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshVolume()
    }

    Text {
        id: content
        anchors.centerIn: parent
        text: root.btDevice
        color: Theme.Palette.text
        font.family: "JetBrains Mono Bold"
        font.pixelSize: 12
        font.bold: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                bluetoothWindow.visible = !bluetoothWindow.visible
            }
        }
    }

    PanelWindow {
        id: bluetoothWindow
        visible: false
        color: "transparent"
        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 100
        }
        implicitWidth: 400
        implicitHeight: 200

        onVisibleChanged: {
            if (visible) {
                root.refreshBt()
                root.refreshVolume()
                volumeTimer.running = true
                btTimer.interval = 5000
            } else {
                volumeTimer.running = false
                btTimer.interval = 30000
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.Palette.surface_container
            border.width: 1
            border.color: Theme.Palette.outline_variant
            radius: 12


            Text {
                text: root.btDevice + ":"
                font.pixelSize: 20
                font.bold: true
                font.family: "JetBrains Mono Bold"
                leftPadding: 12
                topPadding: 15
                color: Theme.Palette.text
            }
            Text {
                text: "Connected: " + root.btDevice
                font.pixelSize: 17
                font.bold: true
                font.family: "JetBrains Mono Bold"
                leftPadding: 12
                topPadding: 60
                color: Theme.Palette.text
            }
            Text {
                text: "MAC address: " + root.deviceMacAdress
                font.pixelSize: 17
                font.bold: true
                font.family: "JetBrains Mono Bold"
                leftPadding: 12
                topPadding: 90
                color: Theme.Palette.text
            }
            Text {
                text: "Volume level: " + root.volLevel
                font.pixelSize: 17
                font.bold: true
                font.family: "JetBrains Mono Bold"
                leftPadding: 12
                topPadding: 120
                color: Theme.Palette.text
            }
            Text {
                text: "Power level: " + root.hpBatText
                font.pixelSize: 17
                font.bold: true
                font.family: "JetBrains Mono Bold"
                leftPadding: 12
                topPadding: 150
                color: Theme.Palette.text
            }
        }
    }
}
