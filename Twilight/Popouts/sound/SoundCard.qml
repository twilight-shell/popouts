import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Twilight.Core

// Sound mixer: output and input volume, the devices to pick from and
// per-app volume for everything currently playing.
Item {
    id: root

    readonly property var nodes: Pipewire.nodes.values
    // `type` is known without tracking; properties and volume are not.
    readonly property var sinks: nodes.filter(n => n.type === PwNodeType.AudioSink)
    readonly property var sources: nodes.filter(n => n.type === PwNodeType.AudioSource)
    readonly property var streams: nodes.filter(n => n.type === PwNodeType.AudioOutStream)

    implicitWidth: 400
    implicitHeight: column.implicitHeight + 40

    // Volume, mute and device props are only live for tracked nodes.
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource, ...root.sinks, ...root.sources, ...root.streams]
    }

    ColumnLayout {
        id: column

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 20
        }
        spacing: 10

        Text {
            text: "✦ Sound"
            color: Theme.star
            font.family: Theme.font
            font.pixelSize: 22
            font.bold: true
            style: Text.Outline
            styleColor: Theme.ink
        }

        SectionTitle {
            Layout.topMargin: 4
            text: "Output"
        }

        VolumeLine {
            Layout.fillWidth: true
            node: Pipewire.defaultAudioSink
        }

        Repeater {
            model: root.sinks

            DeviceRow {}
        }

        SectionTitle {
            Layout.topMargin: 8
            text: "Input"
            visible: root.sources.length > 0
        }

        VolumeLine {
            Layout.fillWidth: true
            visible: Pipewire.defaultAudioSource !== null
            node: Pipewire.defaultAudioSource
            input: true
        }

        Repeater {
            model: root.sources

            DeviceRow {
                input: true
            }
        }

        SectionTitle {
            Layout.topMargin: 8
            text: "Apps"
        }

        StyledText {
            visible: root.streams.length === 0
            text: "✧ nothing is playing"
            color: Theme.muted
            font.pixelSize: 12
        }

        Repeater {
            model: root.streams

            AppRow {}
        }
    }
}
