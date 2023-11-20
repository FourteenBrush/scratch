package scratch

VM :: struct {
    pc: uint,
}

vm_new :: proc() -> VM {
    return VM { 0 }
}
