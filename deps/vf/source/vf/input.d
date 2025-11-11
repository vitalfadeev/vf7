module vf.input;

import core.sys.posix.unistd   : read, close;
import core.sys.posix.fcntl    : open, O_RDONLY, O_NONBLOCK;
import core.sys.posix.sys.time : timeval;
import vf.types;
import vf.key_codes;


struct
Input {
    Device  device;
    Event   event;
    Device* event_device;

    void
    open () {
        device.open_read_only (
            cast(char*)"/dev/input/event8", 
            /* non_blocking */ false
        );        
    }

    bool 
    read () /*@nogc nothrow*/ {
        event_device = &device;
        return device.read (&event);
    }
}

struct 
Device {
    int fd = -1;

    @disable this (this); // non-copyable

    ~this () @nogc nothrow  {
        if (fd >= 0) {
            close (fd);
            fd = -1;
        }
    }

    void
    open_read_only (char* path, bool non_blocking = true) nothrow {
        const flags = non_blocking ? (O_RDONLY | O_NONBLOCK) : O_RDONLY;
        fd = open (path, flags);
        if (fd == 0) {
            import core.stdc.stdio  : fprintf,stderr;
            import core.stdc.stdlib : exit;
            fprintf (stderr,"Failed to open evdev device: %s\n", path);
            exit (1);
        }
    }

    bool 
    read (Event* ev) /*@nogc nothrow*/ {
        static if (Event.sizeof != 24) {
            import core.stdc.stdio  : fprintf,stderr;
            import core.stdc.stdlib : exit;
            fprintf (stderr,"expected on 64-bit: %d\n", Event.sizeof);
            exit (1);
        }
        auto n = .read (fd, ev, Event.sizeof);
        if (n == Event.sizeof) return true;
        return false;
    }
}

struct 
Event {
        timeval time;
    union {
    struct {
        ushort  type;   // 16
        ushort  code;   // 16
        int     value;  // 32
    };
        REG     reg;
    }

    this (REG _reg) {
        reg = _reg;
    }

    bool
    opEquals (REG b) const {
        return reg == b;
    }

    REG
    opCast (T : REG) () {
        return cast(REG) *&this;
    }
}
