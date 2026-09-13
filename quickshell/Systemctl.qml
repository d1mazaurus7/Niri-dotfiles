import QtQuick
import Quickshell
import Quickshell.Widgets
import "theme" as Theme
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: scope

    property string confirmText: ""
    property var confirmCmd: []
    property string confirmNotify: ""
    readonly property bool anyOpen: root.visible || confirmWin.visible

    function confirm(text, cmd, notifyText) {
        confirmText = text
        confirmCmd = cmd
        confirmNotify = (notifyText !== undefined && notifyText !== null) ? notifyText : ""
        root.visible = false
        confirmWin.visible = true
    }

    function runConfirm() {
        if (confirmCmd.length > 0)
            Quickshell.execDetached(confirmCmd)
        if (confirmNotify.length > 0)
            Quickshell.execDetached(["notify-send", "System", confirmNotify])
        confirmWin.visible = false
    }

    function cancelConfirm() {
        confirmWin.visible = false
    }

    // --- затемнение ---
    PanelWindow {
        visible: scope.anyOpen
        color: "transparent"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: scope.anyOpen ? 0.45 : 0
            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.visible = false
                    confirmWin.visible = false
                }
            }
        }
    }

    IpcHandler {
        target: "systemctl"
        function toggle(): void {
            if (confirmWin.visible) {
                confirmWin.visible = false
                return
            }
            root.visible = !root.visible
        }
        function show(): void {
            confirmWin.visible = false
            root.visible = true
        }
        function close(): void {
            root.visible = false
            confirmWin.visible = false
        }
    }

    // --- меню профилей ---
    PanelWindow {
        id: root
        visible: false
        width: 350
        height: 150
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Theme.Palette.background
            border.width: 1
            border.color: Theme.Palette.outline_variant
            radius: 12

            Row {
                id: buttons
                anchors.centerIn: parent
                spacing: 15

                // Sleep
                Rectangle {
                    id: eco_profile
                    width: 80
                    height: 80
                    radius: 10
                    color: Theme.Palette.surface_container
                    transformOrigin: Item.Center
                    scale: ecoMa.containsMouse ? 1.20 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "󰤄"
                        color: Theme.Palette.text
                        font.pixelSize: 30
                        font.family: "JetBrains Mono Bold"
                        font.bold: true
                    }

                    MouseArea {
                        id: ecoMa
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: confirm(
                            "Enter in sleep mode?",
                            ["systemctl", "suspend"],
                            "Good night!"
                        )
                    }
                }

                // Poweroff
                Rectangle {
                    id: default_profile
                    width: 80
                    height: 80
                    radius: 10
                    color: Theme.Palette.surface_container
                    transformOrigin: Item.Center
                    scale: defMa.containsMouse ? 1.20 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: Theme.Palette.text
                        font.pixelSize: 30
                        font.bold: true
                    }

                    MouseArea {
                        id: defMa
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: confirm(
                            "Poweroff?",
                            ["systemctl", "poweroff"],
                            "Bye!"
                        )
                    }
                }

                // Reboot
                Rectangle {
                    id: performance_profile
                    width: 80
                    height: 80
                    radius: 10
                    color: Theme.Palette.surface_container
                    transformOrigin: Item.Center
                    scale: perMa.containsMouse ? 1.20 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: Theme.Palette.text
                        font.pixelSize: 30
                        font.bold: true
                    }

                    MouseArea {
                        id: perMa
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: confirm(
                            "Reboot?",
                            ["systemctl","reboot"],
                            "Rebooting..."
                        )
                    }
                }
            }
        }
    }

    // --- окно подтверждения ---
    PanelWindow {
        id: confirmWin
        visible: false
        width: 320
        height: 140
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Theme.Palette.background
            border.width: 1
            border.color: Theme.Palette.outline_variant
            radius: 12

            Column {
                anchors.centerIn: parent
                spacing: 16
                width: parent.width - 32

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: confirmText
                    color: Theme.Palette.text
                    font.family: "JetBrains Mono Bold"
                    font.bold: true
                    font.pixelSize: 16
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20

                    Rectangle {
                        width: 100
                        height: 36
                        radius: 8
                        color: Theme.Palette.surface_container
                        transformOrigin: Item.Center
                        scale: noMa.containsMouse ? 1.20 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                        }


                        Text {
                            anchors.centerIn: parent
                            text: "no"
                            color: Theme.Palette.text
                            font.family: "JetBrains Mono Bold"
                            font.bold: true
                        }

                        MouseArea {
                            id: noMa
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: cancelConfirm()
                        }
                    }

                    Rectangle {
                        width: 100
                        height: 36
                        radius: 8
                        color: Theme.Palette.on_primary
                        transformOrigin: Item.Center
                        scale: yesMa.containsMouse ? 1.20 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: "yes"
                            color: Theme.Palette.text
                            font.family: "JetBrains Mono Bold"
                            font.bold: true
                        }

                        MouseArea {
                            id: yesMa
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: runConfirm()
                        }
                    }
                }
            }
        }
    }
}

