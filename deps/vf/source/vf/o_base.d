module vf.o_base;

import vf.types       : GO,REG;
import vf.input       : Input,Event;
import vf.local_input : Local_input;

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
