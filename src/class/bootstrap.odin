package classloader

import "core:os"
import "core:fmt"
import "core:path/filepath"
import "reader:reader"

@private
BOOTSTRAP_CLASSES_PATH :: "res/jrt-fs"

load_bootstrap_classes :: proc(using loader: ^ClassLoader) -> (ok: bool) {
    err := filepath.walk(BOOTSTRAP_CLASSES_PATH, load_bootstrap_class, &loaded_classes)
    return !bool(err)
}

@private
load_bootstrap_class :: proc(
    info: os.File_Info, 
    in_err: os.Errno, 
    classes_out: rawptr,
) -> (
    err: os.Errno, 
    skip_dir: bool,
) {
    if info.is_dir do return // skip
    data, read_successful := os.read_entire_file(info.fullpath)
    if !read_successful {
        fmt.eprintln("Error reading file", info.fullpath)
        return err, true // stop further reading
    }

    creader := reader.reader_new(data)
    classfile, cerr := reader.reader_read_classfile(&creader)
    classname := reader.classfile_get_class_name(classfile)
    if cerr != .None {
        fmt.eprintf("Error while deserializing file %v: %v\n", classname, cerr)
        return err, true // stop further reading
    }

    classes_out := cast(^[dynamic]reader.ClassFile)classes_out 
    append(classes_out, classfile)
    return
}
