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
}
