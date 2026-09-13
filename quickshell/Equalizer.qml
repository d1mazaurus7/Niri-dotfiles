// ~/.config/quickshell/ee-presets/EEPresets.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "theme" as Theme

Rectangle {
    id: root
    implicitWidth: content.width + 16 
    implicitHeight: 28
    radius: 12
    color: Theme.Palette.surface_container
    Text {
        id: content
        anchors.centerIn: parent
        text: "Equalizer 󰺢"
        color: Theme.Palette.text
        font.pixelSize: 14
        font.bold: true
        font.family: "JetBrains Mono Bold"
    }
    MouseArea {
        id: eeMa
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            equalizerWindow.visible = !equalizerWindow.visible
        }
    }
    PanelWindow {
        id: equalizerWindow
        property string current: ""
        visible: false
        color: "transparent"
        anchors {
            left: true
            top: true
        }
        margins {
            top: 12
            left: 370
        }
        readonly property var presets: [
            { id: "bass",       label: "Bass" },
            { id: "atmosphere", label: "Atmosphere" },
            { id: "game",       label: "Game" },
            { id: "video",      label: "Video" },
            { id: "default",    label: "Default" }
        ]

        implicitWidth: 300
        implicitHeight: col.implicitHeight + 50

        function loadPreset(name) {
            current = name
            proc.command = ["easyeffects", "--load-preset", name]
            proc.running = false
            proc.running = true
            visible = false
        }

        Process { id: proc; running: false }

        Rectangle {
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
                    text: equalizerWindow.current !== "" ? "now: " + root.current : "EasyEffects"
                    color: Theme.Palette.text
                    font.pixelSize: 11
                    font.family: "JetBrains Mono Bold"
                    Layout.fillWidth: true
                }

                Repeater {
                    model: equalizerWindow.presets
                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: 28
                        radius: 6
                        color: equalizerWindow.current === modelData.id
                               ? Theme.Palette.selected
                               : (ma.containsMouse ? Theme.Palette.hovered : Theme.Palette.border)
                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            font.family: "JetBrains Mono Bold"
                            color: "#eeeeee"
                            font.pixelSize: 12
                        }
                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: equalizerWindow.loadPreset(modelData.id)
                        }
                    }
                }
            }
        }
    }
}


