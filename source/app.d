import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.key_codes    : EVT_KEY_ESC_PRESSED;
import vf.key_codes    : EVT_APP_QUIT;
import vf.key_codes    : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;
import vf.key_codes    : EVT_KEY_A_PRESSED;
import vf.key_codes    : EVT_KEY_Q_PRESSED,EVT_KEY_W_PRESSED,EVT_KEY_E_PRESSED;
import vf.o_base       : O;
import vf.map          : GO_map;
import importc;

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
    EVT_KEY_Q_PRESSED,         _go_play_1,
    EVT_KEY_W_PRESSED,         _go_play_2,
    EVT_KEY_E_PRESSED,         _go_play_3,
);

alias 
go_ctrl_pressed = GO_map!(
    EVT_KEY_LEFTCTRL_RELEASED, _go_ctrl_released,
    EVT_KEY_A_PRESSED,         _go_ctrl_a,
);


//
alias 
_go_quit = GO_quit!"QUIT\n";

alias
_go_esc = GO_local_event_new!EVT_APP_QUIT;

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

alias
_go_ctrl_a = GO_printf!"CTRL+A\n";

alias
_go_a_pressed = GO_printf!"A! OK!\n";

alias
_go_play_1 = GO_play!(1);

alias
_go_play_2 = GO_play!(2);

alias
_go_play_3 = GO_play!(3);

//
void
GO_quit (alias TEXT) (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        printf (TEXT);
        go = null;
    }
}

void
GO_printf (alias TEXT) (void* o, void* e, REG evt, REG d) {
    printf (TEXT);
}

void
GO_local_event_new (REG EVT) (void* o, void* e, REG evt, REG d) {
    printf ("  put Event: 0x%X\n", EVT);
    with (cast(O*)o) {
        local_input.put_reg (EVT);
    }
}

void
GO_play (int resource_id) (void* o, void* e, REG evt, REG d) {
    printf ("Play %d\n", resource_id);
    with (cast(O*)o) {
        audio.play_wav (resource_id);
    }
}
