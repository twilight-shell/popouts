import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Twilight.Core
import "Devices.js" as Devices

// A stream that is playing: its app and a volume slider.
RowLayout {
    id: app

    required property var modelData

    readonly property string appName: modelData.properties["application.name"] || Devices.label(modelData)
    readonly property var entry: DesktopEntries.heuristicLookup(appName) ?? DesktopEntries.heuristicLookup(modelData.properties["application.process.binary"] ?? "")
    // The desktop entry's icon first: the one streams name (Vesktop
    // says "vesktop") often isn't in the theme.
    readonly property string icon: Icons.find([entry?.icon, modelData.properties["application.icon-name"], appName])

    Layout.fillWidth: true
    spacing: 10

    Item {
        implicitWidth: 22
        implicitHeight: 22

        IconImage {
            anchors.fill: parent
            visible: app.icon !== ""
            source: app.icon
        }

        Text {
            anchors.centerIn: parent
            visible: app.icon === ""
            text: "♪"
            color: Theme.star
            font.pixelSize: 18
        }
    }

    StyledText {
        Layout.preferredWidth: 90
        text: app.appName
        font.pixelSize: 12
        elide: Text.ElideRight
    }

    StarSlider {
        Layout.fillWidth: true
        value: app.modelData.audio.volume
        muted: app.modelData.audio.muted
        onMoved: value => app.modelData.audio.volume = value
    }
}
