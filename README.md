# twilight-shell/popouts

[![ci](https://github.com/twilight-shell/popouts/actions/workflows/ci.yml/badge.svg)](https://github.com/twilight-shell/popouts/actions/workflows/ci.yml)

Cards that drop from the top of the screen under the
[bar](https://github.com/twilight-shell/bar): a month **calendar** with the moon
phase, and a **sound mixer** with the output and input devices and the volume of
every app that is playing. Part of the
[twilight-shell](https://github.com/twilight-shell) organization; it works on its
own or as a piece of the full shell.

Click outside or `Esc` closes a card, opening the other one swaps them.

## Requirements

[Quickshell](https://quickshell.org) 0.3 or newer and
[twilight-shell/core](https://github.com/twilight-shell/core) installed, and
PipeWire for the mixer.

## Running on its own

```sh
qs -p /path/to/popouts
qs -p /path/to/popouts ipc call popout toggle calendar   # or sound
```

If `Twilight.Core` is not in a directory Qt searches, point `QML_IMPORT_PATH` at
its parent.

## Using it in a shell

```sh
sudo make install        # to /usr/lib/qt6/qml/Twilight/Popouts
```

```qml
import Twilight.Popouts

Popouts {
    id: popouts
    outputName: "DP-1"      // where to open; the first screen by default
}

Bar {
    activePopout: popouts.open
    onPopoutRequested: name => popouts.toggle(name)
}
```

| | |
|---|---|
| `open` | The card that is open: `""`, `"calendar"` or `"sound"`. Set it, or use the functions below. |
| `toggle(name)`, `close()` | Open a card, or close the one that is open. |
| `outputName` | The output to open on. |
| `push` | Screen y of the bottom of a card that hangs over the right-hand column where notifications stack, `0` when none does. Notifications move below it. |

## Contributing

Contributions are welcome: see [CONTRIBUTING.md](CONTRIBUTING.md). Agents and the like: [AGENTS.md](AGENTS.md).

## License

MIT, see `LICENSE`.
