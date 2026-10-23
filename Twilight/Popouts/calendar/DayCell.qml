import QtQuick
import Twilight.Core

// One day of the month grid: a sticker with a pulsing ring for today, and it
// pops in when the card opens.
Item {
    id: cell

    required property int index
    required property date day
    required property int month
    required property date today

    readonly property bool inMonth: day.getMonth() === month
    readonly property bool isToday: day.toDateString() === today.toDateString()
    readonly property bool weekend: index % 7 >= 5

    property real pop: 0

    width: 320 / 7
    height: 38

    Component.onCompleted: popIn.start()

    SequentialAnimation {
        id: popIn

        PauseAnimation { duration: 120 + cell.index * 9 }
        NumberAnimation { target: cell; property: "pop"; to: 1; duration: 420; easing.type: Easing.OutBack; easing.overshoot: 2.5 }
    }

    Item {
        anchors.fill: parent
        scale: cell.pop * (area.containsMouse ? 1.25 : 1)
        opacity: Math.min(1, cell.pop * 1.5)

        Behavior on scale {
            enabled: cell.pop === 1
            NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 3 }
        }

        // Today
        Rectangle {
            id: ring

            anchors.centerIn: parent
            width: 38
            height: 34
            radius: 12
            color: "transparent"
            border.color: Theme.star
            border.width: 2
            visible: cell.isToday

            ParallelAnimation {
                running: cell.isToday
                loops: Animation.Infinite

                NumberAnimation { target: ring; property: "scale"; from: 0.9; to: 1.35; duration: 1300; easing.type: Easing.OutCubic }
                NumberAnimation { target: ring; property: "opacity"; from: 0.9; to: 0; duration: 1300; easing.type: Easing.OutCubic }
            }
        }

        Sticker {
            anchors.centerIn: parent
            width: 36
            height: 30
            radius: 10
            lift: 3
            fill: Theme.accent
            visible: cell.isToday
        }

        Text {
            anchors.centerIn: parent
            text: cell.day.getDate()
            color: cell.isToday ? Theme.text
                 : !cell.inMonth ? Theme.alpha(Theme.muted, 0.4)
                 : cell.weekend ? Theme.primary
                 : Theme.text
            font.family: Theme.font
            font.pixelSize: 14
            font.bold: cell.isToday
            style: cell.isToday ? Text.Outline : Text.Normal
            styleColor: Theme.ink
        }
    }

    MouseArea {
        id: area

        anchors.fill: parent
        hoverEnabled: true
    }
}
