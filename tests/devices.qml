import QtQuick
import "../Twilight/Popouts/sound/Devices.js" as Devices

// Tests for how the sound mixer names devices and picks their icons. Needs only
// Qt's qml tool:
//     QT_QPA_PLATFORM=offscreen qml tests/devices.qml
// Exits with a non-zero code when a check fails.
Item {
    Component.onCompleted: {
        try {
            run();
        } catch (e) {
            console.log("FAIL exception:", e);
            Qt.exit(1);
        }
    }

    function run() {
        let pass = 0, fails = 0;
        const eq = (name, got, want) => {
            const g = JSON.stringify(got), w = JSON.stringify(want);
            if (g === w) pass++; else { fails++; console.log("FAIL", name, "\n  got ", g, "\n  want", w); }
        };

        const monitor = 0xf0379, headphones = 0xf02cb, speaker = 0xf04c3, microphone = 0xf036c;
        const node = (name, description = "", nickname = "") => ({ name, description, nickname });

        // the name: nickname, else description, else the node's own name
        eq("nickname first", Devices.label(node("alsa_output.pci", "Built-in Audio", "Desk speakers")), "Desk speakers");
        eq("description next", Devices.label(node("alsa_output.pci", "Built-in Audio")), "Built-in Audio");
        eq("the name last", Devices.label(node("alsa_output.pci")), "alsa_output.pci");
        eq("no node", Devices.label(null), "");
        eq("undefined node", Devices.label(undefined), "");

        // the icon
        eq("hdmi", Devices.glyph(node("alsa_output.hdmi-stereo", "HDMI / DisplayPort"), false), monitor);
        eq("displayport", Devices.glyph(node("x", "DisplayPort 2"), false), monitor);
        eq("usb", Devices.glyph(node("alsa_output.usb-Logitech", "Logitech"), false), headphones);
        eq("headset", Devices.glyph(node("x", "Wireless Headset"), false), headphones);
        eq("headphones", Devices.glyph(node("x", "Headphones"), false), headphones);
        eq("case doesn't matter", Devices.glyph(node("X", "HDMI Output"), false), monitor);
        eq("anything else is a speaker", Devices.glyph(node("alsa_output.pci", "Built-in Audio"), false), speaker);
        eq("an input is a microphone", Devices.glyph(node("alsa_input.usb", "USB Mic"), true), microphone);
        eq("an input without a node", Devices.glyph(null, true), microphone);
        eq("no node yet is a speaker", Devices.glyph(null, false), speaker);
        eq("a node without a description", Devices.glyph({ name: "alsa_output.hdmi" }, false), monitor);

        console.log("DEVICES TESTS:", pass, "passed,", fails, "failed");
        Qt.exit(fails === 0 ? 0 : 1);
    }
}
