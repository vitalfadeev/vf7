module vf.o_base;

import vf.types       : GO,REG;
import vf.input       : Input,Event;
import vf.local_input : Local_input;
import vf.state       : State;
import vf.map         : GO_map;

///
struct
O {
    GO          go = &_go;
    Input       input;
    Local_input local_input;
    void*       ego;
    // update
    // output
    // wait

    void
    open () {
        input.open ();
        local_input.open ();
    }

    // base
    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        with (cast(O*)o)
        while (go !is null) {
            auto ret = input.read ();
            if (!ret) continue;

            // process input event
            evt = input.event.reg;
            _go2 (o,ego,evt,d);
        }
    }

    // with local input
    static
    void
    _go2 (void* o, void* e, REG evt, REG d) {
        with (cast(O*)o) {
            // process input event
            //writefln ("Event  type,code,value: 0x%02X, %X, %s", input.event.type, input.event.code, input.event.value);
            _go3 (o,e,evt,d);

            // each local input event
            while (!local_input.empty) {
                local_input.read ();
                // process local input event
                evt = local_input.event.reg;
                _go3 (o,e,evt,d);
            }
        }
    }

    // with map
    static
    void
    _go3 (void* o, void* e, REG evt, REG d) {
        with (cast(O*)o) {
            if (e !is null) {
                (*cast (GO*) e) (o,e,evt,d);
            }
        }
    }
}

struct
O_base {
    GO go = &_go;

    static
    void 
    _go (void* a, void* b, REG c, REG d) {
        with (cast(O_stated*)a) {
            //
        }
    };
}

struct
O_alt {
    GO go = &go_base;

    static
    void 
    go_base (void* a, void* b, REG c, REG d) {
        with (cast(O_alt*)a) {
            go = &go_alt;
        }
    };

    static
    void 
    go_alt (void* a, void* b, REG c, REG d) {
        with (cast(O_alt*)a) {
            go = &go_base;
        }
    };
}

struct
O_stated {
    GO    go = &_go;
    void* state = cast (void*) &States.state_base;

    struct
    States {
        static 
        __gshared {
            State_base state_base;
            State_alt  state_alt;
        }
    }

    static
    void 
    _go (void* a, void* b, REG c, REG d) {
        with (cast(O_stated*)a) {
            (cast (State*) state).go (a,b,c,d);
        }
    };

    struct
    State {
        GO go = &_go;
    }

    struct
    State_base {
        State _state = State (&_go);
        void* custom_field;

        static
        void 
        _go (void* a, void* b, REG c, REG d) {
            with (cast(O_stated*)a) {
                state = &States.state_alt;
            }
        };
    }

    struct
    State_alt {
        State _state = State (&_go);
        void* custom_field;

        static
        void 
        _go (void* a, void* b, REG c, REG d) {
            with (cast(O_stated*)a) {
                state = &States.state_base;
            }
        };
    }
}


// input  line
// direct line
// 1   2   3   4   5   6   7
// key key key             key
//             drt drt drt 

// map
//   to text
//   text to map
//
// map
//   to_text
// editor
//   fields
//     lineno,inlinepos  // x,y
//     complete_list
//   complete_list
// text
//   to_map
//
