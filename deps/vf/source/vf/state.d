module vf.state;

import vf.types;
import vf.map;

struct
State {
    GO   go  = &_go;
    //Map* map;

    this (GO _go) {
        this.go = _go;
    }

    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        //if (e !is null)
        //    process_map (o,e,evt,d, (cast (State*)e).map);
    };

    static
    void
    process_map (void* o, void* e, REG evt, REG d,  Map* map) {
        auto rec = map.recs.ptr;
        auto RCX = map.recs.length;
        for (; RCX != 0; rec++, RCX--)
            if (evt == rec.key)
                rec.go (o,e,evt,d);
    }
}
