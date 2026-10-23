import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Twilight.Core
import "calendar"
import "sound"

// Cards that drop from the top of the screen under the bar: the calendar
// under the clock and the sound mixer under the volume. Click outside or
// Esc closes, opening another one swaps the card.
Scope {
    id: root

    // The card that is open: "", "calendar" or "sound".
    property string open: ""
    // Name of the output to open on; the first screen when empty or unknown.
    // The compositor is the host's business, so the host sets it.
    property string outputName: ""
    // Screen y of the bottom of a card that hangs over the right-hand column
    // where notifications stack, 0 when none does. Notifications move below it.
    readonly property real push: window.push

    function toggle(name: string): void {
        open = open === name ? "" : name;
    }

    function close(): void {
        open = "";
    }

    // `qs -c shell ipc call popout toggle calendar`
    IpcHandler {
        target: "popout"

        function toggle(name: string): void {
            root.toggle(name);
        }
    }

    PanelWindow {
        id: window

        // What is rendered; lags behind `open` while the close animation plays.
        property string current: ""
        // Set by hand, not bound to the animations, so the window never
        // unmaps for a frame between them.
        property bool shown: false
        // 1 = above the screen, 0 = in place.
        property real drop: 1
        property real swing: 0

        // Follows the card live, so notifications get shoved as it drops in.
        readonly property real push: shown && card.x + card.width > width - 420 ? Math.max(0, card.y + card.height + 8) : 0

        visible: shown
        screen: Quickshell.screens.find(s => s.name === root.outputName) ?? Quickshell.screens[0]
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        WlrLayershell.namespace: "twilight-popout"
        // Top, not Overlay: notifications live on Overlay and must stay above the cards.
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: root.open !== "" ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Connections {
            target: root

            function onOpenChanged() {
                if (root.open === "") {
                    openAnim.stop();
                    closeAnim.restart();
                    return;
                }
                closeAnim.stop();
                if (!window.shown || window.current === "")
                    window.drop = 1;
                else
                    window.drop = 0.4;
                window.current = root.open;
                window.shown = true;
                openAnim.restart();
                Qt.callLater(() => keys.forceActiveFocus());
            }
        }

        ParallelAnimation {
            id: openAnim

            NumberAnimation { target: window; property: "drop"; to: 0; duration: 620; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
            SequentialAnimation {
                NumberAnimation { target: window; property: "swing"; from: -6; to: 3; duration: 380; easing.type: Easing.OutQuad }
                NumberAnimation { target: window; property: "swing"; to: 0; duration: 520; easing.type: Easing.OutBack; easing.overshoot: 2 }
            }
        }

        SequentialAnimation {
            id: closeAnim

            ParallelAnimation {
                NumberAnimation { target: window; property: "drop"; to: 1; duration: 300; easing.type: Easing.InBack; easing.overshoot: 1.3 }
                NumberAnimation { target: window; property: "swing"; to: 4; duration: 300 }
            }
            ScriptAction {
                script: {
                    window.shown = false;
                    window.current = "";
                }
            }
        }

        FocusScope {
            id: keys

            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: root.close()

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }

            Item {
                id: card

                readonly property int restY: 66

                width: loader.item ? loader.item.implicitWidth : 0
                height: loader.item ? loader.item.implicitHeight : 0
                x: window.current === "sound" ? parent.width - width - Theme.gap * 2 : (parent.width - width) / 2
                y: restY - window.drop * (restY + height + 40)
                rotation: window.swing
                transformOrigin: Item.Top

                Behavior on height {
                    NumberAnimation { duration: 300; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                }

                // Swallow clicks so they don't close the card.
                MouseArea {
                    anchors.fill: parent
                }

                Sticker {
                    anchors.fill: parent
                    radius: 22
                    lift: 8
                    fill: Theme.surface
                }

                Loader {
                    id: loader

                    anchors.fill: parent
                    sourceComponent: window.current === "calendar" ? calendar : window.current === "sound" ? sound : null
                }
            }
        }

        Component {
            id: calendar
            CalendarCard {}
        }

        Component {
            id: sound
            SoundCard {}
        }
    }
}
