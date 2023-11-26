package thread

import "core:mem"

INITIAL_STACK_SIZE :: 40
MAX_STACK_SIZE :: mem.Megabyte / size_of(StackFrame)

CallStack :: struct {
    frames: [dynamic]StackFrame, 
}

callstack_new :: proc() -> CallStack {
    return CallStack {
        frames = make([dynamic]StackFrame),
    }
}

callstack_destroy :: proc(using stack: CallStack) {
    for &frame in frames {
        delete(frame.locals)
        delete(frame.operand_stack)
    }
}

stack_pop :: proc(using stack: ^CallStack) -> StackFrame {
    return pop(&frames)
}

stack_push :: proc(using stack: ^CallStack, frame: StackFrame) {
    if len(frames) > MAX_STACK_SIZE {
        // TODO: throw StackOverflow exception
    }
    append(&frames, frame)
}

StackFrame :: struct {
    locals: []Variable,
    operand_stack: []Variable,
}

Variable :: union {
    i8,     // byte
    i32,    // int
    i64,    // long
    f32,    // float
    f64,    // double
    Object, // reference
}

Object :: struct {}
