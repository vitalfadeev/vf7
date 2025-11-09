module vf.o_base;

import vf.types       : GO,REG;
import vf.input       : Input,Event;
import vf.local_input : Local_input;
import vf.state       : State;
import vf.map         : Map;

///
struct
O {
    GO                 go = &_go;
    Input              input;
    Local_input!Event  local_input;
    State*             state;

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
            _go2 (o,e,evt,d);
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
            if (state !is null) {
                process_map (o,e,evt,d, &state.map);
            }
        }
    }

    static
    void
    process_map (void* o, void* e, REG evt, REG d,  Map* map) {
        auto rec = map.recs.ptr;
        auto RCX = map.recs.length;
        for (; RCX != 0; rec++, RCX--)
            if (evt == rec.key)
                rec.go (o,e,evt,d);
    }


    //E*                 main_e;
    //App_input_event    app_input_event;

    //static
    //void
    //_go (O* o, void* e, REG evt, REG d) {
    //    // global_context
    //    // each global input event
    //    with (o)
    //    while (doit) {
    //        auto ret = global_input.read (&app_input_event.input_event);
    //        if (!ret) continue;

    //        evt = app_input_event.input_event.reg;

    //        // E
    //        if (e !is null) {
    //            auto m = cast (E*) e;
    //            m.state.go (o,m,evt,0);
    
    //            // each local input event
    //            while (!local_input.empty) {
    //                local_input.read (&app_input_event.input_event);
    //                evt = app_input_event.input_event.reg;
    //                // process local input event
    //                m.state.go (o,m,evt,0);
    //            }
    //        }
    //    }
    //}
}


struct
E {
    State* state;
}



// input  line
// direct line
// 1   2   3   4   5   6   7
// key key key             key
//             drt drt drt 




struct
App_input_event {
    Event event;  // read ("/dev/input/eventX", &app_input_event.input_event, 1);
    int   ext1;
    int   ext2;
}



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
