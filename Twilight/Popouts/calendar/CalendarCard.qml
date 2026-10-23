import QtQuick
import QtQuick.Layouts
import Quickshell
import Twilight.Core

// Month calendar. Arrows or the scroll wheel flip months with a slide,
// today is a pink sticker with a pulsing ring, days pop in when the card
// opens. The footer shows the moon phase.
Item {
    id: root

    readonly property var locale: Qt.locale("en_US")
    readonly property date today: clock.date

    property int year: today.getFullYear()
    property int month: today.getMonth()
    property int dir: 1
    // Month to land on after the slide instead of the neighbouring one.
    property var target: null

    // Days before the 1st that belong to the previous month (weeks start on Monday).
    readonly property int lead: (new Date(year, month, 1).getDay() + 6) % 7

    readonly property real moonPhase: Astro.moonPhase(today)
    readonly property string moonName: Astro.moonName(moonPhase)
    readonly property int dayOfYear: Math.floor((today - new Date(today.getFullYear(), 0, 1)) / 86400000) + 1

    implicitWidth: 360
    implicitHeight: column.implicitHeight + 40

    function shift(d) {
        if (slide.running)
            return;
        dir = d;
        slide.restart();
    }

    function goToday() {
        const delta = (today.getFullYear() - year) * 12 + today.getMonth() - month;
        if (delta === 0 || slide.running)
            return;
        target = { year: today.getFullYear(), month: today.getMonth() };
        shift(delta > 0 ? 1 : -1);
    }

    function applyShift() {
        const d = target ? new Date(target.year, target.month, 1) : new Date(year, month + dir, 1);
        target = null;
        year = d.getFullYear();
        month = d.getMonth();
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    SequentialAnimation {
        id: slide

        ParallelAnimation {
            NumberAnimation { target: grid; property: "x"; to: -root.dir * 50; duration: 140; easing.type: Easing.InQuad }
            NumberAnimation { target: grid; property: "opacity"; to: 0; duration: 140 }
            NumberAnimation { target: header.title; property: "opacity"; to: 0; duration: 140 }
        }
        ScriptAction {
            script: {
                root.applyShift();
                grid.x = root.dir * 50;
            }
        }
        ParallelAnimation {
            NumberAnimation { target: grid; property: "x"; to: 0; duration: 420; easing.type: Easing.OutBack; easing.overshoot: 1.6 }
            NumberAnimation { target: grid; property: "opacity"; to: 1; duration: 200 }
            NumberAnimation { target: header.title; property: "opacity"; to: 1; duration: 250 }
        }
    }

    ColumnLayout {
        id: column

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 20
        }
        spacing: 12

        StyledText {
            text: root.locale.toString(root.today, "dddd, d MMMM")
            color: Theme.muted
            font.pixelSize: 12
        }

        MonthHeader {
            id: header

            Layout.fillWidth: true
            locale: root.locale
            month: root.month
            year: root.year

            onPreviousRequested: root.shift(-1)
            onTodayRequested: root.goToday()
            onNextRequested: root.shift(1)
        }

        // Weekdays
        Row {
            Layout.fillWidth: true

            Repeater {
                model: 7

                StyledText {
                    required property int index

                    width: 320 / 7
                    horizontalAlignment: Text.AlignHCenter
                    text: root.locale.dayName((index + 1) % 7, Locale.ShortFormat).slice(0, 2)
                    color: index >= 5 ? Theme.accent : Theme.muted
                    font.pixelSize: 11
                }
            }
        }

        // Days
        Item {
            Layout.fillWidth: true
            implicitHeight: 6 * 38

            Grid {
                id: grid

                columns: 7

                Repeater {
                    model: 42

                    DayCell {
                        day: new Date(root.year, root.month, 1 - root.lead + index)
                        month: root.month
                        today: root.today
                    }
                }
            }

            WheelHandler {
                onWheel: event => root.shift(event.angleDelta.y > 0 ? -1 : 1)
            }
        }

        MoonFooter {
            Layout.fillWidth: true
            phase: root.moonPhase
            name: root.moonName
            dayOfYear: root.dayOfYear
        }
    }
}
