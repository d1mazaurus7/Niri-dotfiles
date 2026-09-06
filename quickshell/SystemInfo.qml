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
    property real cpuUsage: 0
    property string ramLabel: "RAM: --"

    QtObject {
        id: cpu
        property var prev: null
    }

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = (text || "").split("\n")[0]
                const p = line.trim().split(/\s+/).slice(1).map(Number)
                if (p.length < 4)
                    return

                const idle = p[3] + (p[4] || 0)
                const total = p.reduce((a, b) => a + b, 0)

                if (cpu.prev) {
                    const dIdle = idle - cpu.prev.idle
                    const dTotal = total - cpu.prev.total
                    root.cpuUsage = dTotal > 0 ? (1 - dIdle / dTotal) * 100 : 0
                }
                cpu.prev = { idle, total }
            }
        }
    }

    Process {
        id: memProc
        command: ["cat", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text || ""
                const total = Number(t.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0)
                const avail = Number(t.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0)
                if (!total) {
                    root.ramLabel = "RAM: ?"
                    return
                }
                const used = total - avail
                const gb = n => (n / 1024 / 1024).toFixed(1)
                root.ramLabel = `RAM: ${gb(used)} / ${gb(total)}G`
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = false
            memProc.running = false
            cpuProc.running = true
            memProc.running = true
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 12

        Text {
            color: Theme.Palette.on_surface
            font.pixelSize: root.fontSize
            font.bold: true
            text: "CPU: " + root.cpuUsage.toFixed(0) + "%"
        }

        Text {
            color: Theme.Palette.on_surface
            font.pixelSize: root.fontSize
            font.bold: true
            text: root.ramLabel
        }
    }
}
