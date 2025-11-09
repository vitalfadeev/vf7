module vf.state;

import vf.types;
import vf.map;

struct
State {
    Map map;
    GO  go  = &_go;

    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        // evt = value_code_type
        //
        // EV_MSC timestamp
        // EV_KEY code is_pressed
        // EV_SYN SYN_REPORT
        //
        // EV_MSC timestamp
        // EV_KEY code is_released
        // EV_SYN SYN_REPORT

        // KEY[] keys
        // ACT[] acts
        
        //auto rec = (cast (E*) e).state.map.recs.ptr;
        //auto RCX = (cast (E*) e).state.map.recs.length;
        //for (; RCX != 0; rec++, RCX--)
        //    if (evt == rec.key)
        //        rec.act.go (o,e,evt,d);
    };
}
