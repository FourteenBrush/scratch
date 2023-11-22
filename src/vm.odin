package scratch

import "class"

VM :: struct {
    bootstrap_classloader: class.ClassLoader,
}

vm_new :: proc() -> VM {
    return VM {
        bootstrap_classloader = class.classloader_new(),
    }
}

vm_destroy :: proc(using vm: VM) {
    class.classloader_destroy(bootstrap_classloader) 
}
