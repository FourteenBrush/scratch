package class

import "core:os"
import "core:fmt"
import "core:mem"
import "core:path/filepath"
import "classreader:reader"

@private
BOOTSTRAP_CLASSES_PATH :: "res/jrt-fs"

ClassLoader :: struct {
    classes_arena: ^mem.Arena,
    classes_allocator: mem.Allocator,
    loaded_classes: [dynamic]reader.ClassFile,
}

classloader_new :: proc() -> ClassLoader {
    classes_arena := new(mem.Arena)
    mem.arena_init(classes_arena, make([]u8, 2 * mem.Megabyte))
    allocator := mem.arena_allocator(classes_arena)

    return ClassLoader {
        classes_arena = classes_arena,
        classes_allocator = allocator,
        loaded_classes = make([dynamic]reader.ClassFile/*, allocator*/),
    }
}

classloader_destroy :: proc(using classloader: ClassLoader) {
    for &class in loaded_classes {
        reader.classfile_destroy(class, classes_allocator)
    }
    delete(loaded_classes)
    free_all(classes_allocator)
    free(classes_arena)

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
    classfile, cerr := reader.reader_read_classfile(&creader, classloader.classes_allocator)
    if cerr != .None {
        classname := reader.classfile_get_class_name(classfile) // hoping this got read successfully
        fmt.eprintf("Error while reading class file %v: %v\n", classname, cerr)
        return err, true // stop further bootstrapping
    }

    append(&classloader.loaded_classes, classfile)
    return
}
