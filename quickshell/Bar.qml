import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "theme" as Theme

Scope {
    id: root

    Equalizer { 
        id: eePresets 
    }

    PanelWindow {
        id: bar

        anchors {
            top: true
            left: true
            right: true
        }
        margins {
            top: 8
            left: 10
            right: 10
        }

        implicitHeight: 40
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bar"
        WlrLayershell.keyboardFocus: eePresets.visible
            ? WlrKeyboardFocus.OnDemand
            : WlrKeyboardFocus.None
        Shortcut {
            sequence: "Escape"
            enabled: eePresets.visible
            onActivated: eePresets.visible = false
        }
        Rectangle {
            id: bg
            border.width: 1
            border.color: Theme.Palette.outline_variant
            anchors.fill: parent
            color: Theme.Palette.surface
            radius: 20

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.Palette.pad ?? 10
                anchors.rightMargin: Theme.Palette.pad ?? 10
                spacing: 12

                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: 10
                    implicitHeight: 10
                    radius: 5
                    color: Theme.Palette.primary
                        ?? Theme.Palette.accent
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text: "NixOS"
                    color: Theme.Palette.on_surface
                        ?? Theme.Palette.text
                    font.pixelSize: 15
                    font.bold: true
                }
                Cava {
                    Layout.leftMargin: 10
                }
                Player {}


                Volume_pill {}

                Item { Layout.fillWidth: true } // spacer

                Rectangle {
                    id: eeBtn
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: 6
                    color: Theme.Palette.surface_container
                    Text {
                        anchors.centerIn: parent
                        text: "󰺢"
                        color: Theme.Palette.text
                        font.pixelSize: 16
                        font.bold: true
                    }
                    MouseArea {
                        id: eeMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            eePresets.anchor.window = bar
                            eePresets.anchor.item = eeBtn
                            eePresets.anchor.edges = Edges.Bottom | Edges.Left
                            eePresets.anchor.gravity = Edges.Bottom | Edges.Left
                            eePresets.toggle()
                        }
                    }
                }

                Text {
                    id: clock
                    Layout.alignment: Qt.AlignVCenter
                    color: Theme.Palette.on_surface
                        ?? Theme.Palette.text
                    font.pixelSize: 13
                    font.bold: true
                    text: Qt.formatDateTime(new Date(), "ddd dd MMM  hh:mm")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text =
                            Qt.formatDateTime(new Date(), "ddd dd MMM  hh:mm")
                    }
                }

                Item { Layout.fillWidth: true }
                Wifi {}
                Volume {}
                SystemInfo {}
            }
        }
    }
}
