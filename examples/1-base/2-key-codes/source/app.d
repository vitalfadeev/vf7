import std.stdio    : writeln,writefln;
import vf.types     : GO,REG;
import vf.input     : Input,Event;
import vf.key_codes : EVT_KEY_ESC_PRESSED;

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

    void
    open () {
        input.open ();
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
            writefln ("Event  type,code,value: 0x%02X, %X, %s", input.event.type, input.event.code, input.event.value);

            // quit on ESC
            if (evt == EVT_KEY_ESC_PRESSED) {
                writeln ("QUIT");
                go = null;
            }
        }
    }
}
