package scratch

import "core:log"
import "class"
import "thread"

VM :: struct {
    bootstrap_classloader: class.ClassLoader,
}

vm_new :: proc() -> VM {
    return VM {
        bootstrap_classloader = class.classloader_new(),
    }
}

vm_bootstrap_runtime :: proc(using vm: ^VM) -> (ok: bool) {
    class.classloader_bootstrap(&bootstrap_classloader) or_return
    log.debugf("Loaded %v runtime classes", len(bootstrap_classloader.loaded_classes))
    return true
}

vm_start :: proc(using vm: ^VM) {
    main_thread := thread.context_init()
    defer thread.context_destroy(main_thread)

    log.debug(main_thread)
}

vm_destroy :: proc(using vm: VM) {
    class.classloader_destroy(bootstrap_classloader) 
}
