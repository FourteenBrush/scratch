package scratch

import "core:fmt"
import "class"
import "cli:cli"

main :: proc() {
    app := cli.App {}
    cli.add_flag(&app, &cli.Flag {
        short = "-h",
        long = "--help",
        help = "Some help message",
    })

    vm := vm_new()
    defer vm_destroy(vm)

    class.load_bootstrap_classes(&vm.bootstrap_classloader)
    fmt.println(len(vm.bootstrap_classloader.loaded_classes))
}
