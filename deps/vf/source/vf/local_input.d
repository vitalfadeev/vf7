module vf.local_input;

import vf.input    : Event;
import vf.bc_array : Array;
import vf.types    : REG;

//
struct
Local_input {
    Array!Local_event s;
    Local_event       event;

    void
    open () {
        s.setup (8);
    }

    void
    read () {
        event = s[0];
        s.remove_at (0);
    }

    bool
    empty () {
        return s.length == 0;
    }

    void
    put (Local_event* evt) {
        s.add (*evt);
    }

    void
    put_reg (REG _reg) {
        s.add (Local_event (_reg));
    }

    void
    put_reg (REG _reg, void* e) {
        s.add (Local_event (_reg,e));
    }
}

struct
Local_event {
    Event event;
    void* e;

    this (REG _reg) {
        event.reg = _reg;
    }

    this (REG _reg, void* _e) {
        event.reg = _reg;
        e         = _e;
    }
}
