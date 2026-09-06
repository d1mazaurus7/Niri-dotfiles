// ~/.config/quickshell/ee-presets/EEPresets.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "theme" as Theme


PopupWindow {
    id: root
    property string current: ""
    visible: false
    color: "transparent"

    readonly property var presets: [
        { id: "bass",       label: "Bass" },
        { id: "atmosphere", label: "Atmosphere" },
        { id: "game",       label: "Game" },
        { id: "video",      label: "Video" },
        { id: "default",    label: "Default" }
    ]

    implicitWidth: 300
    implicitHeight: col.implicitHeight + 50

    function toggle() {
        visible = !visible
    }

    function loadPreset(name) {
        current = name
        proc.command = ["easyeffects", "--load-preset", name]
        proc.running = false
        proc.running = true
        visible = false
    }

    Process { id: proc; running: false }

    Rectangle {
        id: box
        anchors.fill: parent
        radius: 10
        color: Theme.Palette.bgAlt 
        border.color: Theme.Palette.border
        border.width: 2

        ColumnLayout {
            id: col
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            Text {
                text: root.current !== "" ? "now: " + root.current : "EasyEffects"
                color: Theme.Palette.text
                font.pixelSize: 11
                Layout.fillWidth: true
            }

            Repeater {
                model: root.presets
                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 28
                    radius: 6
                    color: root.current === modelData.id
                           ? Theme.Palette.selected
                           : (ma.containsMouse ? Theme.Palette.hovered : Theme.Palette.border)
                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: "#eeeeee"
                        font.pixelSize: 12
                    }
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.loadPreset(modelData.id)
                    }
                }
            }
        }
    }
}
