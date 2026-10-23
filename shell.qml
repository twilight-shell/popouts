import Quickshell
import Twilight.Popouts

// Standalone entry: `qs -p /path/to/popouts`, then
// `qs -p /path/to/popouts ipc call popout toggle calendar` (or sound).
ShellRoot {
    Popouts {}
}
