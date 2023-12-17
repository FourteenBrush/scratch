package class

import "core:os"
import "core:fmt"
import "core:mem"
import "core:path/filepath"
import "classreader:reader"

@private
BOOTSTRAP_CLASSES_PATH :: "res/jrt-fs"

ClassLoader :: struct {
    // FIXME: do we actually need a parent, as the other classloaders
    // will be represented by java code
    parent: ^ClassLoader,
    classes_arena: mem.Allocator,
    loaded_classes: [dynamic]reader.ClassFile,
}

classloader_new :: proc() -> ClassLoader {
    classes_arena: mem.Arena
    mem.arena_init(&classes_arena, make([]u8, mem.Megabyte))

    return ClassLoader {
        classes_arena = mem.arena_allocator(&classes_arena),
        loaded_classes = make([dynamic]reader.ClassFile),
    }
}

classloader_bootstrap :: proc(using classloader: ^ClassLoader) -> (ok: bool) {
    err := filepath.walk(BOOTSTRAP_CLASSES_PATH, load_bootstrap_class, classloader)
    return err == 0
}

@private
load_bootstrap_class :: proc(
    info: os.File_Info,
    in_err: os.Errno,
    classloader_ptr: rawptr,
) -> (
    err: os.Errno,
    skip_dir: bool,
) {
    if info.is_dir do return // skip
    data, read_successful := os.read_entire_file(info.fullpath)
    if !read_successful {
        fmt.eprintln("Error reading file", info.fullpath)
        return err, true // stop further bootstrapping
    }

    classloader := cast(^ClassLoader)classloader_ptr
    creader := reader.reader_new(data)
    classfile, cerr := reader.reader_read_classfile(&creader, classloader.classes_arena)
    classname := reader.classfile_get_class_name(classfile) // hoping this got read successfully
    if cerr != .None {
        fmt.eprintf("Error while reading class file %v: %v\n", classname, cerr)
        return err, true // stop further bootstrapping
    }

    append(&classloader.loaded_classes, classfile)
    return
}

classloader_destroy :: proc(using classloader: ClassLoader) {
    for &class in loaded_classes {
        reader.classfile_destroy(class)
    }
    delete(loaded_classes)
}
