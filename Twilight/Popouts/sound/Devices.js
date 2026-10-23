.pragma library

// What to call a Pipewire node and which icon fits it.
function label(node) {
    if (!node)
        return "";
    return node.nickname || node.description || node.name;
}

// nf-md glyphs: monitor, headphones, speaker, microphone
function glyph(node, input) {
    if (input)
        return 0xf036c;
    // Pipewire connects a moment after it is first used: no node yet.
    if (!node)
        return 0xf04c3;
    const n = (node.name + " " + node.description).toLowerCase();
    if (n.includes("hdmi") || n.includes("displayport"))
        return 0xf0379;
    if (n.includes("usb") || n.includes("headset") || n.includes("headphone"))
        return 0xf02cb;
    return 0xf04c3;
}
