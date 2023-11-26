package classloader

import "reader:reader"

ClassLoader :: struct {
    // FIXME: do we actually need a parent, as the other classloaders
    // will be represented by java code
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
