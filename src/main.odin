package scratch

import "core:os"
import "core:fmt"
import "class"
import "cli:cli"

_ :: cli.get_flag_names

main :: proc() {
    app := cli.App {}
    app.action = proc(app: cli.App, manager: cli.Manager) {}
    cli.add_flag(&app, &cli.Flag {
        short = "-h",
        long = "--help",
        help = "Some help message",
    })

    cli.run(&app, os.args)

    vm := vm_new()
    defer vm_destroy(vm)

    class.load_bootstrap_classes(&vm.bootstrap_classloader)
    fmt.println(len(vm.bootstrap_classloader.loaded_classes))
}
