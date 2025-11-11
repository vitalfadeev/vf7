import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.key_codes    : EVT_KEY_ESC_PRESSED;
import vf.key_codes    : EVT_APP_QUIT;
import vf.key_codes    : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;
import vf.key_codes    : EVT_KEY_A_PRESSED;
import vf.key_codes    : EVT_KEY_Q_PRESSED;
import vf.o_base       : O;
import vf.state        : State;
import vf.map          : Map;
import vf.e_base       : E;
import vf.map          : Map_init;
import vf.map          : process_map;

extern(C) 
void 
main () {
    Stacked_e ego;

    O o;
    o.ego = &ego;
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
        mixin (Map_init!(
            EVT_KEY_ESC_PRESSED,       _go_esc,
        ));

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
        mixin (Map_init!(
            EVT_APP_QUIT,              _go_quit,
            EVT_KEY_LEFTCTRL_PRESSED,  _go_ctrl_pressed,
            EVT_KEY_A_PRESSED,         _go_a_pressed,
            /* EVT_KEY_Q_PRESSED,         _go_play_a), */
        ));

        process_map (o,e,evt,d, &map);
    }

    static
    void 
    state_ctrl_pressed (void* o, void* e, REG evt, REG d) {
        mixin (Map_init!(
            EVT_KEY_LEFTCTRL_RELEASED, _go_ctrl_released,
            EVT_KEY_A_PRESSED,         _go_ctrl_a,
        ));

        process_map (o,e,evt,d, &map);
    }
}



//
void
_go_quit (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("QUIT\n");
        go = null;
    }
}


void
_go_esc (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        // generate new event and put into local input
        printf ("  put Event: APP_CODE_QUIT\n");
        local_input.put_reg (EVT_APP_QUIT);
    }
}

void
_go_ctrl_pressed (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL pressed\n");
        *cast(GO*)e = &States.state_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        *cast(GO*)e = &States.state_base;
    }
}

void
_go_ctrl_a (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("CTRL+A\n");
    }
}

void
_go_a_pressed (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("A! OK!\n");
    }
}


__gshared
GO_play _go_play_a = GO_play (&GO_play._go, cast(char*)"Play A");

struct
GO_play {
    GO    go = &_go;
    char* text;

    static
    void
    _go (void* o, void* e, REG evt, REG d) {
        with (cast(GO_play*)e) {
            if (text)
                printf ("%s\n", text);
        }
    }
}
