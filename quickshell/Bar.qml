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
                    text: ""
                    color: Theme.Palette.on_surface
                        ?? Theme.Palette.text
                    font.pixelSize: 20
                    font.bold: true
                }
                Cava {
                    Layout.leftMargin: 10
                }
                Player {}
                Equalizer{}


                Volume_pill {}



                Text {
                    id: clock
                    Layout.alignment: Qt.AlignVCenter
                    color: Theme.Palette.on_surface
                    ?? Theme.Palette.text
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 15
                    font.bold: true
                    font.family: "JetBrains Mono Bold"
                    text: Qt.formatDateTime(new Date(), "ddd, dd MMM, hh:mm")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text =
                            Qt.formatDateTime(new Date(), "ddd, dd MMM, hh:mm")
                    }
                }
                PowerProfiles {}
                Systemctl{}

                Item { Layout.fillWidth: true }
                Tray {
                    barWindow: bar
                }
                Wifi {}
                Volume {}
                Bluetooth{}
                SystemInfo {}
            }
        }
    }
}
