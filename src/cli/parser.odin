package cli

import "core:fmt"
import "core:mem"
import "core:strconv"
import "core:strings"

VmOptions :: struct {
    // initial heap size in bytes, as specified via -Xms<size>
    initial_heap: Maybe(int),
    // max size of the heap in bytes, as specified via -Xmx<size>
    max_heap: Maybe(int),
}

parse_options :: proc(args: []string) -> (options: VmOptions) {
    for arg in args {
        switch arg {
            case "-Xbatch":
                fmt.println("-Xbatch")
            case: parse_option_with_value(&options, arg)
        }
    }

    return options
}

@private
parse_option_with_value :: proc(options: ^VmOptions, arg: string) {
    switch {
        case strings.has_prefix(arg, "-Xms"):
            length: int
            initial_heap, ok := strconv.parse_int(arg[len("-Xms"):], n=&length)
            assert(ok)
            unit := arg[len("-Xms") + length]
            switch unit {
                case 'M': initial_heap *= mem.Megabyte
                case 'G': initial_heap *= mem.Gigabyte
                case: panic("-Xms: unrecognized unit")
            }

            options.initial_heap = initial_heap
    }
}
