package classloader

import reader "shared:common"

ClassLoader :: struct {
    parent: ^ClassLoader,
    loaded_classes: [dynamic]reader.ClassFile,
}

classloader_new :: proc() -> ClassLoader {
    return ClassLoader {
        loaded_classes = make([dynamic]reader.ClassFile),
    }
}

classloader_destroy :: proc(using classloader: ClassLoader) {
    delete(loaded_classes)
}
