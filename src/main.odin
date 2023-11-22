package scratch

import "core:os"
import "core:fmt"
import "core:path/filepath"

import reader "shared:common"

main :: proc() {
    runtime_classes, ok := load_runtime_classes()
    defer delete(runtime_classes)
    if !ok {
        fmt.eprintln("Error while reading runtime base classes")
        os.exit(1)
    }

    fmt.println("OK")
}

@private
load_runtime_classes :: proc() -> (classes: [dynamic]reader.ClassFile, ok: bool) {
    classes = make([dynamic]reader.ClassFile, 32)
    class_out: reader.ClassFile

    err := filepath.walk("res/jrt-fs", load_class, &class_out)
    if err != 0 do return classes, false

    append(&classes, class_out)
    return classes, true
}

@private
load_class :: proc(info: os.File_Info, in_err: os.Errno, class_out: rawptr) -> (err: os.Errno, skip_dir: bool) {
    if info.is_dir do return // skip
    data, ok := os.read_entire_file(info.fullpath)
    if !ok {
        fmt.eprintf("Error reading file %v\n", info.fullpath)
        return
    }

    freader := reader.reader_new(data)
    class, cerr := reader.reader_read_class_file(&freader)
    classinfo := reader.cp_get(reader.ConstantClassInfo, class, class.this_class)
    classname := reader.cp_get_str(class, classinfo.name_idx)
    if cerr != .None {
        fmt.eprintf("Error while deserializing file %v: %v\n", classname, cerr)
        skip_dir = true // stop any further reading of classes
        return
    }
    class_out := cast(^reader.ClassFile)class_out
    class_out^ = class
    fmt.println(classname)
    return
}
