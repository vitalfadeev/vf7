import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.key_codes    : EVT_KEY_ESC_PRESSED;
import vf.key_codes    : EVT_APP_QUIT;
import vf.key_codes    : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;
import vf.key_codes    : EVT_KEY_A_PRESSED;
import vf.key_codes    : EVT_KEY_Q_PRESSED;
import vf.o_base       : O;
import vf.map          : GO_map;

extern(C) 
void 
main () {
    GO_stacked go_stacked;

    O o;
    o.ego = &go_stacked;
    o.open ();
    o.go (&o,null,0,0);
}

struct
GO_stacked {
    GO _this = &go_stacked;
    GO _next = &go_base;

    static
    void 
    go_stacked (void* o, void* e, REG evt, REG d) {
        go_stacked_this (o,e,evt,d);

        with (cast(GO_stacked*)e) {
            _next (o,&_next,evt,d);
        }
    }
}

//
alias
go_stacked_this = GO_map!(
    EVT_KEY_ESC_PRESSED,       _go_esc,
);

alias 
go_base = GO_map!(
    EVT_APP_QUIT,              _go_quit,
    EVT_KEY_LEFTCTRL_PRESSED,  _go_ctrl_pressed,
    EVT_KEY_A_PRESSED,         _go_a_pressed,
    /* EVT_KEY_Q_PRESSED,         _go_play_a), */
);

alias 
go_ctrl_pressed = GO_map!(
    EVT_KEY_LEFTCTRL_RELEASED, _go_ctrl_released,
    EVT_KEY_A_PRESSED,         _go_ctrl_a,
);


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
        *cast(GO*)e = &go_ctrl_pressed;
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf ("> CTRL released\n");
        *cast(GO*)e = &go_base;
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
