import Quickshell
import Quickshell.Io
import QtQuick
import "theme" as Theme

Rectangle {
    id: root

    property int barWidth: 4
    property int barHeight: 22
    property int barSpacing: 3
    property var values: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    implicitWidth: content.implicitWidth + 16
    implicitHeight: barHeight + 8
    radius: 8
    color: Theme.Palette.surface_container

    function barColor(v) {
        const t = Math.min(1, Math.max(0, v / 100))
        if (t > 0.8) return Theme.Palette.tertiary
        if (t > 0.45) return Theme.Palette.secondary
        return Theme.Palette.primary
    }

    Process {
        id: cava
        running: true
        command: ["sh", "-c", "exec cava -p \"$HOME/.config/cava/quickshell.conf\""]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                const nums = line.trim().split(";").map(Number).filter(n => !Number.isNaN(n))
                if (nums.length)
                    root.values = nums
            }
        }

        stderr: SplitParser {
            onRead: line => console.log("[cava]", line)
        }

        onExited: code => console.log("[cava] exited", code)
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: root.barSpacing
        height: root.barHeight

        Repeater {
            model: root.values

            Rectangle {
                width: root.barWidth
                height: Math.max(3, (modelData / 100) * root.barHeight)
                anchors.bottom: parent.bottom
                radius: 2
                color: root.barColor(modelData)
            }
        }
    }
}
