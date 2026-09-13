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


// VARS
    property int fontSize: 13
    property string netIcon: "󰤮"
    property string netLabel: "offline"
    property string networkIp: "…"
    property string activeInterface: "—"
    property string publicIp: ""
    property int signalDbm: 0
    property int signalPct: dbmToPct(signalDbm)
    property string netIface: activeInterface

    property real rxBytes: 0
    property real txBytes: 0
    property real prevRx: 0
    property real prevTx: 0
    property real rxSpeed: 0
    property real txSpeed: 0
    property bool netReady: false

// FUNCTIONS
    function humanBytes(n) {
        if (n < 1024) return n + " B"
        if (n < 1024 * 1024) return (n / 1024).toFixed(1) + " KB"
        if (n < 1024 * 1024 * 1024) return (n / 1024 / 1024).toFixed(1) + " MB"
        return (n / 1024 / 1024 / 1024).toFixed(2) + " GB"
    }

    function humanRate(n) {
        if (n < 1024) return Math.round(n) + " B/s"
        if (n < 1024 * 1024) return (n / 1024).toFixed(1) + " KB/s"
        return (n / 1024 / 1024).toFixed(2) + " MB/s"
    }

    function dbmToPct(dbm) {
        if (dbm >= -40) return 100
        if (dbm <= -90) return 0
        return Math.round((dbm + 90) * (100 / 50))
    }

// PROCESSES

// SHOW DOWNLOADED BYTES
    Process {
        id: byteProc
        command: [
            "sh", "-c",
            `iface="${root.netIface}"
[ -d "/sys/class/net/$iface" ] || iface=$(iw dev 2>/dev/null | awk '/Interface/{print $2; exit}')
[ -n "$iface" ] || exit 0
rx=$(cat /sys/class/net/$iface/statistics/rx_bytes 2>/dev/null || echo 0)
tx=$(cat /sys/class/net/$iface/statistics/tx_bytes 2>/dev/null || echo 0)
echo "$rx $tx"`
        ]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const p = this.text.trim().split(/\s+/)
                if (p.length < 2) return

                const rx = parseFloat(p[0]) || 0
                const tx = parseFloat(p[1]) || 0

                if (root.netReady) {
                    root.rxSpeed = Math.max(0, rx - root.prevRx)
                    root.txSpeed = Math.max(0, tx - root.prevTx)
                } else {
                    root.netReady = true
                }

                root.prevRx = rx
                root.prevTx = tx
                root.rxBytes = rx
                root.txBytes = tx
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            byteProc.running = false
            byteProc.running = true
            signalProc.running = true
            
        }
    }

// SHOW PUBLIC IP
    Process {
        id: publicIpProc
        command: [
            "curl", "-s", "--max-time", "3", "ifconfig.me"
        ]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim()
                publicIp = t.length ? t : "—"
            }
        }
    }

// SIGNAL STRENGTH
    Process {
        id: signalProc
        command: [
            "sh", "-c",
            `iface=$(iw dev 2>/dev/null | awk '/Interface/{print $2; exit}')
[ -n "$iface" ] || exit 0
iw dev "$iface" link 2>/dev/null | awk '/signal:/ {print $2}'`
        ]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim()
                signalDbm = t.length ? parseInt(t, 10) : 0
            }
        }
    }

// WIFI INTERFACE
    Process {
        id: wifiInterfaceProc
        command: [
            "sh", "-c",
            "ip -o route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i==\"dev\"){print $(i+1); exit}}'"
        ]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim()
                activeInterface = t.length ? t : "—"
            }
        }
    }

// GET WIFI IP
    Process {
        id: getIpProc
        command: ["hostname", "-I"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(/\s+/)
                root.networkIp = parts[0] || "—"
            }
        }
    }

// WIFI PILL IN BAR PROC
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


// PILL IN THE BAR
    Row {
        id: content
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: root.netIcon
            color: Theme.Palette.on_surface
            font.pixelSize: root.fontSize
            font.family: "JetBrains Mono Bold"
        }
        Text {
            text: root.netLabel
            color: Theme.Palette.on_surface
            font.pixelSize: root.fontSize
            font.bold: true
            font.family: "JetBrains Mono Bold"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    networkWindow.visible = !networkWindow.visible
                    getIpProc.running = true
                    wifiInterfaceProc.running = true
                    publicIpProc.running = true
                    signalProc.running = true
                }
            }
        }
    }

// NETWORK WINDOW
    PanelWindow {
        id: networkWindow
        visible: false
        color: "transparent"
        anchors {
            right: true
            top: true
        }
        margins {
            top: 12
            right: 80
        }
        implicitWidth: 500
        implicitHeight: 300
        Rectangle {
            anchors.fill: parent
            color: Theme.Palette.surface_container
            border.width: 1
            border.color: Theme.Palette.outline_variant
            radius: 10
            Text {
                text: root.netLabel
                color: Theme.Palette.text
                font.pixelSize: 20
                leftPadding: 12
                topPadding: 12
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            onVisibleChanged: if (visible) getIp()
            Text {
                text: "WiFi IP: " + root.networkIp
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 120
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            Text {
                text: "Public IP: " + root.publicIp
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 150
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            Text {
                text: "Connected: " + root.netLabel
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 60
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            Text {
                text: "Interdace: " + root.activeInterface
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 90
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            Text {
                text: {
                    const p = root.signalPct
                    let bars = ""
                    if (p <= 0) bars = "✕"
                    if (p < 30) bars = "▂"
                    if (p < 50) bars = "▂▄"
                    if (p < 70) bars = "▂▄▆"
                    else bars = "▂▄▆█"
                    return p <= 0
                        ? "Signal: —"
                        : "Signal: " + p + "%" + " " + bars
                }
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 180
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            Text {
                text: "Total in this session:       ↓ " + humanBytes(root.rxBytes) + "  ↑ " + humanBytes(root.txBytes)
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 210
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }
            Text {
                text: "Current speed:               ↓ " + humanRate(root.rxSpeed) + "  ↑ " + humanRate(root.txSpeed)
                color: Theme.Palette.text
                font.pixelSize: 15
                leftPadding: 12
                topPadding: 240
                font.family: "JetBrains Mono Bold"
                font.bold: true
            }

        }
    }
}
