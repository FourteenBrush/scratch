package scratch

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"
import "cli"

// TODO: get cli dependency out of here

main :: proc() {
    when ODIN_DEBUG {
        alloc: mem.Tracking_Allocator
        mem.tracking_allocator_init(&alloc, context.allocator)
        context.allocator = mem.tracking_allocator(&alloc)

        defer {
            if len(alloc.allocation_map) > 0 {
                fmt.eprintf("=== %v allocations not freed: ===\n", len(alloc.allocation_map))
                for _, entry in alloc.allocation_map {
                    fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
                }
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

    opt := log.Default_Console_Logger_Opts - {.Line, .Short_File_Path}
    context.logger = log.create_console_logger(opt = opt)
    defer log.destroy_console_logger(context.logger)

    cli.parse_options(os.args)

    vm := vm_new()
    defer vm_destroy(vm)

    vm_bootstrap_runtime(&vm)
    vm_start(&vm)
}
