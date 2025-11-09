import std.stdio      : writeln,writefln;
import vf.types       : GO,REG;
import vf.input       : Input,Event;
import vf.key_codes   : EVT_KEY_ESC_PRESSED;
import vf.local_input : Local_input;
import vf.key_codes   : APP_CODE_QUIT;
import vf.key_codes   : EVT_KEY_LEFTCTRL_PRESSED,EVT_KEY_LEFTCTRL_RELEASED;

void
main () {
    O o;
    o.open ();
    o.go (&o,null,0,0);
}

struct
O {
    GO     go = &_go;
    Input  input;
    Local_input!(Event) local_input;
    State* state = new 
        State (
            Map ([
                Map.Rec (EVT_KEY_ESC_PRESSED,   &_go_esc),
                Map.Rec (APP_CODE_QUIT,         &_go_quit),
                Map.Rec (EVT_KEY_LEFTCTRL_PRESSED, &_go_ctrl_pressed),
            ])
        );

    void
    open () {
        input.open ();
        local_input.open ();
    }

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
}

static
void
_go2 (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        // process input event
        writefln ("Event  type,code,value: 0x%02X, %X, %s", input.event.type, input.event.code, input.event.value);
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

static
void
_go3 (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        process_map (o,e,evt,d, &state.map);
    }
}

static
void
_go_quit (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("QUIT");
        go = null;
    }
}

void
process_map (void* o, void* e, REG evt, REG d,  Map* map) {
    auto rec = map.recs.ptr;
    auto RCX = map.recs.length;
    for (; RCX != 0; rec++, RCX--)
        if (evt == rec.key)
            rec.go (o,e,evt,d);
}


struct
Map {
    Rec[] recs;

    struct
    Rec {
        KEY key;
        GO  go;
    }
}

alias KEY = REG;

//
void
_go_esc (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        // generate new event and put into local input
        writeln ("  put Event: APP_CODE_QUIT");
        Event event_quit;
        event_quit.reg = APP_CODE_QUIT;
        local_input.put (&event_quit);
    }
}

struct
State {
    Map map;
}

//
void
_go_ctrl_pressed (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("> CTRL pressed");
        state = new 
            State (
                Map ([
                    Map.Rec (EVT_KEY_LEFTCTRL_RELEASED, &_go_ctrl_released),
                ])
            );
    }
}

void
_go_ctrl_released (void* o, void* e, REG evt, REG d) {
    with (cast(O*)o) {
        writeln ("> CTRL released");
        state = new 
            State (
                Map ([
                    Map.Rec (EVT_KEY_ESC_PRESSED,   &_go_esc),
                    Map.Rec (APP_CODE_QUIT,         &_go_quit),
                    Map.Rec (EVT_KEY_LEFTCTRL_RELEASED, &_go_ctrl_pressed),
                ])
            );
    }
}
