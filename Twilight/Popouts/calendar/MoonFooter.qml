import QtQuick
import Twilight.Core

// The moon phase and how far into the year it is.
Sticker {
    id: root

    required property real phase
    required property string name
    required property int dayOfYear

    implicitHeight: 52
    radius: 14
    lift: 3
    fill: Theme.surfaceHigh

    Row {
        anchors.verticalCenter: parent.verticalCenter
        x: 12
        spacing: 12

        Moon {
            anchors.verticalCenter: parent.verticalCenter
            phase: root.phase

            SequentialAnimation on rotation {
                loops: Animation.Infinite

                NumberAnimation { to: 8; duration: 2600; easing.type: Easing.InOutSine }
                NumberAnimation { to: -8; duration: 2600; easing.type: Easing.InOutSine }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            StyledText {
                text: root.name
                color: Theme.primary
                font.pixelSize: 13
            }

            StyledText {
                text: "day " + root.dayOfYear + " of the year"
                color: Theme.muted
                font.pixelSize: 11
            }
        }
    }
}
