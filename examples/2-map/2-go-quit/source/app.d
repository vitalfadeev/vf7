import std.stdio      : writeln,writefln;
import vf.types       : GO,REG;
import vf.input       : Input,Event;
import vf.key_codes   : EVT_KEY_ESC_PRESSED;
import vf.local_input : Local_input;
import vf.key_codes   : APP_CODE_QUIT;

void
main () {
	O o;
    o.open ();
	o.go (&o,null,0,0);
}

struct
O {
    GO    go = &_go;
    Input input;
    Local_input!(Event) local_input;

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
        // quit on ESC
        if (evt == EVT_KEY_ESC_PRESSED) {
            // generate new event and put into local input
            writeln ("  put Event: APP_CODE_QUIT");
            Event event_quit;
            event_quit.reg = APP_CODE_QUIT;
            local_input.put (&event_quit);
        }

        if (evt == APP_CODE_QUIT) {
            _go_quit (o,e,evt,d);
        }
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

