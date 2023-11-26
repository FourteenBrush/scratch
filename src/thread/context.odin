package thread

ThreadContext :: struct {
    callstack: CallStack,
    pc: uint,
}

context_init :: proc() -> ThreadContext {
    return ThreadContext {
        callstack = callstack_new(),
        pc = 0,
    }
}

context_destroy :: proc(using ctx: ThreadContext) {
    callstack_destroy(callstack)
}
