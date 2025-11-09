module vf.local_input;

import vf.input : Event;
import vf.bc_array : Array;

//
struct
Local_input {
    Array!Event s;
    Event       event;

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
    put (Event* evt) {
        s.add (*evt);
    }

    void
    put_reg (typeof (Event.reg) _reg) {
        s.add (Event (_reg));
    }
}
