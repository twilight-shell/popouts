import QtQuick
import QtQuick.Layouts
import Twilight.Core

// The month and year with the arrows and the "today" star.
RowLayout {
    id: root

    required property var locale
    required property int month
    required property int year

    // The month and year, which the card fades while it slides.
    property alias title: monthTitle

    signal previousRequested
    signal todayRequested
    signal nextRequested

    spacing: 8

    Row {
        id: monthTitle

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: root.locale.standaloneMonthName(root.month)
            color: Theme.star
            font.family: Theme.font
            font.pixelSize: 24
            font.bold: true
            style: Text.Outline
            styleColor: Theme.ink
        }

        StyledText {
            anchors.baseline: parent.children[0].baseline
            text: root.year
            color: Theme.primary
            font.pixelSize: 15
        }
    }

    Repeater {
        model: [
            { glyph: "‹", action: () => root.previousRequested() },
            { glyph: "✦", action: () => root.todayRequested() },
            { glyph: "›", action: () => root.nextRequested() }
        ]

        Tap {
            required property var modelData

            implicitWidth: 30
            implicitHeight: 28
            fill: Theme.surfaceHigh
            hoverFill: Theme.secondary
            onClicked: modelData.action()

            StyledText {
                anchors.centerIn: parent
                text: modelData.glyph
                font.pixelSize: 15
                color: Theme.text
            }
        }
    }
}
