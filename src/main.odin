package scratch

import "core:mem"
import "core:fmt"
import "cli:cli"

main :: proc() {
    when ODIN_DEBUG {
        alloc: mem.Tracking_Allocator
        mem.tracking_allocator_init(&alloc, context.allocator)
        context.allocator = mem.tracking_allocator(&alloc)

        defer {
            if len(alloc.allocation_map) > 0 {
                size := 0
                fmt.eprintf("=== %v allocations not freed: ===\n", len(alloc.allocation_map))
                for _, entry in alloc.allocation_map {
                    fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
                    size += entry.size
                }
                fmt.eprintln("Allocated", size / 1024, "KB")
            }
            if len(alloc.bad_free_array) > 0 {
                fmt.eprintf("=== incorrect frees: ===\n", len(alloc.bad_free_array))
                for entry in alloc.bad_free_array {
                    fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
                }
            }
            mem.tracking_allocator_destroy(&alloc)
        }
    }

    app := cli.App {}
    app.action = proc(app: cli.App, manager: cli.Manager) {}
    cli.add_flag(&app, &cli.Flag {
        short = "-h",
        long = "--help",
        help = "Some help message",
    })

    cli.run(&app)

    vm := vm_new()
    defer vm_destroy(vm)

    vm_bootstrap_runtime(&vm)
    fmt.println("a")
    fmt.println(len(vm.bootstrap_classloader.loaded_classes))
}
