import std.stdio      : writeln,writefln;
import vf.types       : GO,REG;
import vf.key_codes   : EVT_KEY_ESC_PRESSED;
import vf.key_codes   : EVT_APP_QUIT;
import vf.key_codes   : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;
import vf.key_codes   : EVT_KEY_A_PRESSED;
import vf.o_base      : O;
import vf.state       : State;
import vf.map         : Map;
import vf.e_base      : E;

void
main () {
    O o;
    o.ego = new Stacked_e ();
    o.open ();
    o.go (&o,null,0,0);
}

struct
Stacked_e {
    GO _this = &_this_state;
    GO _next = &States.state_base;

    //GO         go;  // = go
    //State.go   go;  // = go
    //E.State.go go;  // = go

    static
    void 
    _this_state (void* o, void* e, REG evt, REG d) {
        static Map map = {1, [
            Map.Rec (EVT_KEY_ESC_PRESSED,       &_go_esc),
        ]};

        process_map (o,e,evt,d, &map);
        with (cast(Stacked_e*)e) {
            _next (o,&_next,evt,d);
        }
    }
}

// global keys - translate
// local keys  - quit, ctrl+a

//
struct
States {
    static
    void 
    state_base (void* o, void* e, REG evt, REG d) {
        static Map map = {3, [
            Map.Rec (EVT_APP_QUIT,              &_go_quit),
            Map.Rec (EVT_KEY_LEFTCTRL_PRESSED,  &_go_ctrl_pressed),
            Map.Rec (EVT_KEY_A_PRESSED,         &_go_a_pressed),
        ]};

        process_map (o,e,evt,d, &map);
    }

    static
    void 
    state_ctrl_pressed (void* o, void* e, REG evt, REG d) {
        static __gshared Map map = {2, [
            Map.Rec (EVT_KEY_LEFTCTRL_RELEASED, &_go_ctrl_released),
            Map.Rec (EVT_KEY_A_PRESSED,         &_go_ctrl_a),
        ]};

        process_map (o,e,evt,d, &map);
    }
}

void
process_map (void* o, void* e, REG evt, REG d,  Map* map) {
    auto RCX = map.length;
    auto rec = map.ptr;
    for (; RCX != 0; rec++, RCX--)
        if (evt == rec.key)
            rec.go (o,e,evt,d);
}


//
void
_go_quit (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("QUIT");
        go = null;
    }
}


void
_go_esc (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        // generate new event and put into local input
        writeln ("  put Event: APP_CODE_QUIT");
        local_input.put_reg (EVT_APP_QUIT);
    }
}

void
_go_ctrl_pressed (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("> CTRL pressed");
        *cast(GO*)e = &States.state_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("> CTRL released");
        *cast(GO*)e = &States.state_base;
    }
}

void
_go_ctrl_a (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("CTRL+A");
    }
}

void
_go_a_pressed (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("A! OK!");
    }
}


struct
GO_play {
    GO     go = &_go;
    string text;

    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        with (cast(GO_play*)e) {
            writeln (text);
        }
    }
}
