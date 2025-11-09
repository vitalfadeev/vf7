module vf.input;

import core.sys.posix.unistd   : read, close;
import core.sys.posix.fcntl    : open, O_RDONLY, O_NONBLOCK;
import core.sys.posix.sys.time : timeval;
import std.exception           : enforce;
import vf.types;
import vf.key_codes;


struct
Input {
    Device  device;
    Event   event;
    Device* event_device;

    void
    open () {
        device = 
            Device.open_read_only (
                "/dev/input/event8", 
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

    ~this () @nogc {
        if (fd >= 0) {
            close (fd);
            fd = -1;
        }
    }

    static 
    Device
    open_read_only (string path, bool non_blocking = true) {
        const flags = non_blocking ? (O_RDONLY | O_NONBLOCK) : O_RDONLY;
        auto d = Device ();
        d.fd = open (path.ptr, flags);
        enforce (d.fd >= 0, "Failed to open evdev device: " ~ path);
        return d;
    }

    bool 
    read (Event* ev) /*@nogc nothrow*/ {
        static if (Event.sizeof != 24) {
            pragma (msg, Event.sizeof);
            assert (0, "expected on 64-bit");
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
