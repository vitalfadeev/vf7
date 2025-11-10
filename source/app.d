import std.stdio      : writeln,writefln;
import vf.types       : REG;
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
    o.ego = cast (E*) new Stacked_e ();
    o.open ();
    o.go (&o,o.ego,0,0);
}

struct
Stacked_e {
    E _this = E (_this_state);
    E _next = E (States.state_base);

    //GO         go;  // = go
    //State.go   go;  // = go
    //E.State.go go;  // = go

    static 
    auto
    _this_state () { 
        static __gshared Map map = Map ([
            Map.Rec (EVT_KEY_ESC_PRESSED,       &_go_esc),
        ]);
        return State (&_go, &map);
    }

    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        with (cast(Stacked_e*)e) {
            _this.state._go (o,&_this,evt,d);
            _next.state._go (o,&_next,evt,d);
        }
    };
}

// global keys - translate
// local keys  - quit, ctrl+a

//
struct
States {
    static {
        auto
        state_base () { 
            static __gshared Map map = Map ([
                Map.Rec (EVT_APP_QUIT,              &_go_quit),
                Map.Rec (EVT_KEY_LEFTCTRL_PRESSED,  &_go_ctrl_pressed),
                Map.Rec (EVT_KEY_A_PRESSED,         &_go_a_pressed),
            ]);
            return State (&map);
        }

        auto
        state_ctrl_pressed () { 
            static __gshared Map map = Map ([
                Map.Rec (EVT_KEY_LEFTCTRL_RELEASED, &_go_ctrl_released),
                Map.Rec (EVT_KEY_A_PRESSED,         &_go_ctrl_a),
            ]);
            return State (&map);
        }
    }
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
        *cast(State*)e = States.state_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("> CTRL released");
        *cast(State*)e = States.state_base;
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
