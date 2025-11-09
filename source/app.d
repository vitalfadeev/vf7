import std.stdio;
import vf.types;
import vf.key_codes;

void
main () {
    E_translate e;

	O o = 
        O (
            &e._ths
        );

	o.global_input.input_device = 
		Input_device.open_read_only (
            "/dev/input/event8", 
            /* non_blocking */ false
        );

	o.go (
		&o,
		o.main_e,
		0,
		0
	);
}

__gshared:
struct
E_translate {
    E _ths = E (&state_global_translate);
    E next = E (&state_base);

    __gshared
    State state_global_translate = State ( 
        Map ([
            Map.Rec (EVT_KEY_ESC_PRESSED,       &act_put_quit),
        ]),
        &_global_translate_go
    );

    static
    void
    _global_translate_go (O* o, void* e, REG evt, REG d) {
        // translate
        State._go (o,e,evt,d);  // base go
        // next
        auto m = &((cast(E_translate*)e).next);
        m.state.go (o,m,evt,d);
    }
}

State state_base = State ( 
    Map ([
        Map.Rec (EVT_KEY_A_PRESSED,         &act_writeln_OK),
        Map.Rec (EVT_KEY_LEFTCTRL_PRESSED,  &act_ctrl),
        Map.Rec (EVT_APP_QUIT,              &act_quit),
    ])
);

State state_ctrl_pressed = State (
    Map ([
        Map.Rec (EVT_KEY_LEFTCTRL_RELEASED, &act__init_default_map),
        Map.Rec (EVT_KEY_A_PRESSED,         &act_writeln_CTRL_A),
    ])
);

Act act_put_quit = Act (
    "put_quit",
    (o,e,evt,d) { 
        Input_event _evt; 
        _evt.reg = EVT_APP_QUIT; 
        o.local_input.put (&_evt);
    }
);

Act act_writeln_OK = Act (
    "writeln_OK",
    (o,e,evt,d) { 
        writeln ("OK!"); 
    }
);

Act act_quit = Act (
    "Quit",
    (o,e,evt,d) { 
        o.doit = false;
    }
);

Act act_ctrl = Act (
    "Ctrl",
    (o,e,evt,d) { 
        (cast(E*)e).state = &state_ctrl_pressed;
        writeln ("ctrl!");
        writeln ("> state ctrl_pressed");
    }
);
Act act_writeln_CTRL_A = Act (
    "Ctrl",
    (o,e,evt,d) { 
        writeln ("CTRL_A!");
    }
);

Act act__init_default_map = Act (
    "init_default_map",
    (o,e,evt,d) { 
        (cast(E*)e).state = &state_base;
        writeln ("> state base");
    }
);

// play sound
// - load wav
// PipeWire
// - ctx
// - stream
// - connect to pw-service
// - send data to pw-buffer
// - process callback events
