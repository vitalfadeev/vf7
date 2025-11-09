import std.stdio      : writeln,writefln;
import vf.types       : REG;
import vf.key_codes   : EVT_KEY_ESC_PRESSED;
import vf.key_codes   : EVT_APP_QUIT;
import vf.key_codes   : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;
import vf.key_codes   : EVT_KEY_A_PRESSED;
import vf.o_base      : O;
import vf.state       : State;
import vf.map         : Map;

void
main () {
    O o;
    o.state = cast(State*)&e_state_base;
    o.open ();
    o.go (&o,o.state,0,0);
}

// global keys - translate
// local keys  - quit, ctrl+a

//
__gshared
State state_base =
    State (
        Map ([
            Map.Rec (EVT_APP_QUIT,              &_go_quit),
            Map.Rec (EVT_KEY_LEFTCTRL_PRESSED,  &_go_ctrl_pressed),
            Map.Rec (EVT_KEY_A_PRESSED,         &_go_a_pressed),
        ])
    );

__gshared
State state_ctrl_pressed =
    State (
        Map ([
            Map.Rec (EVT_KEY_LEFTCTRL_RELEASED, &_go_ctrl_released),
            Map.Rec (EVT_KEY_A_PRESSED,         &_go_ctrl_a),
        ])
    );

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
        (cast(E_state*)state)._next = &state_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("> CTRL released");
        (cast(E_state*)state)._next = &state_base;
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

//
struct
E_state {
    State  _this;
    State* _next;

    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        with (cast(E_state*)e) {
            State._go (o,e,evt,d);
            _next. go (o,_next,evt,d);
        }
    };
}

__gshared
E_state e_state_base =
    E_state (
        // global
        State (
            Map ([
                Map.Rec (EVT_KEY_ESC_PRESSED,       &_go_esc),
            ]),
            &E_state._go
        ),
        // local
        &state_base
    );

