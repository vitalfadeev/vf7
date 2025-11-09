module vf.local_input;

//
struct
Local_input (EVT) {
    EVT[] s;
    EVT   event;

    void
    open () {
        //
    }

    void
    read () {
        event = s[0];
        s = s[1..$];
    }

    bool
    empty () {
        return s.length == 0;
    }

    void
    put (EVT* evt) {
        s ~= *evt;
    }

    void
    put_reg (typeof (EVT.reg) _reg) {
        s ~= EVT (_reg);
    }
}
