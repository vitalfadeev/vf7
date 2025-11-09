import std.stdio : writeln,writefln;
import vf.types  : GO,REG;
import vf.input  : Input;

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
        while (1) {
            auto ret = input.read ();
            if (!ret) continue;

            // process input event
            evt = input.event.reg;
            writefln ("Event.type: 0x%02X", input.event.type);
        }
    }
}
