import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Twilight.Core
import "Devices.js" as Devices

// A device to pick; the chosen one is lit with a star.
Tap {
    id: row

    required property var modelData
    required property int index
    property bool input: false
    readonly property bool chosen: input ? Pipewire.defaultAudioSource === modelData : Pipewire.defaultAudioSink === modelData

    Layout.fillWidth: true
    implicitHeight: 38
    radius: 12
    lift: row.chosen ? 1 : 3
    fill: row.chosen ? Theme.secondary : Theme.surfaceHigh
    hoverFill: row.chosen ? Theme.secondary : Theme.border

    onClicked: {
        if (input)
            Pipewire.preferredDefaultAudioSource = modelData;
        else
            Pipewire.preferredDefaultAudioSink = modelData;
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
        }
        spacing: 10

        Text {
            text: String.fromCodePoint(Devices.glyph(row.modelData, row.input))
            color: row.chosen ? Theme.star : Theme.primary
            font.family: Theme.font
            font.pixelSize: 15
        }

        StyledText {
            Layout.fillWidth: true
            text: Devices.label(row.modelData)
            color: row.chosen ? Theme.text : Theme.muted
            font.pixelSize: 12
            elide: Text.ElideRight
        }

        Text {
            id: mark

            text: "★"
            color: Theme.star
            font.pixelSize: 16
            style: Text.Outline
            styleColor: Theme.ink
            scale: row.chosen ? 1 : 0
            rotation: row.chosen ? 0 : -180

            Behavior on scale {
                NumberAnimation { duration: 450; easing.type: Easing.OutBack; easing.overshoot: 3 }
            }
            Behavior on rotation {
                NumberAnimation { duration: 500; easing.type: Easing.OutBack }
            }
        }
    }
}
