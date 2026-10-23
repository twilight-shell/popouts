import QtQuick
import QtQuick.Layouts
import Twilight.Core
import "Devices.js" as Devices

// Big volume slider with a mute button for one node.
RowLayout {
    id: line

    required property var node
    property bool input: false

    spacing: 12

    Tap {
        implicitWidth: 34
        implicitHeight: 34
        fill: line.node?.audio?.muted ? Theme.surfaceHigh : Theme.accent
        hoverFill: Theme.star
        onClicked: line.node.audio.muted = !line.node.audio.muted

        Text {
            anchors.centerIn: parent
            text: String.fromCodePoint(line.node?.audio?.muted ? (line.input ? 0xf036d : 0xf0581) : Devices.glyph(line.node, line.input))
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 16
            style: Text.Outline
            styleColor: Theme.ink
        }
    }

    StarSlider {
        Layout.fillWidth: true
        value: line.node?.audio?.volume ?? 0
        muted: line.node?.audio?.muted ?? false
        onMoved: value => line.node.audio.volume = value
    }

    RollText {
        Layout.preferredWidth: 34
        text: Math.round((line.node?.audio?.volume ?? 0) * 100)
        color: Theme.text
        pixelSize: 13
        bold: true
        duration: 220
    }
}
