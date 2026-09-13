import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Row {
    id: root
    required property var barWindow
    spacing: 6

    Repeater {
        model: SystemTray.items

        MouseArea {
            id: item
            required property var modelData

            implicitWidth: 18
            implicitHeight: 18
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            IconImage {
                anchors.fill: parent
                source: item.modelData.icon
            }

            onClicked: event => {
                if (event.button === Qt.LeftButton)
                    item.modelData.activate()
                else if (event.button === Qt.MiddleButton)
                    item.modelData.secondaryActivate()
                else if (event.button === Qt.RightButton)
                    menu.open()
            }

            QsMenuAnchor {
                id: menu
                menu: item.modelData.menu
                anchor.window: root.barWindow
                anchor.item: item
            }
        }
    }
}
