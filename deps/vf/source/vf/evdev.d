module vf.evdev;

import vf.fd;
import vf.fd_importc;
import vf.evdev_importc;


struct
Evdev {
    libevdev* dev;
    @disable this();

    this (Evdev b) {
        dev = libevdev_new ();
    }

    ~this () {
        libevdev_free (dev);
    }

    int
    set_fd (int fd) {
        return libevdev_set_fd (dev,fd);
    }

    int
    next_event (uint flags, Evdev_event* ev) {
        return libevdev_next_event (dev,flags,cast(input_event*)ev);
    }

    const(char)*
    get_name () {
        return libevdev_get_name (cast(libevdev*)dev);
    }

    int
    get_id_bustype () {
        return libevdev_get_id_bustype (dev);
    }

    int
    get_id_vendor () {
        return libevdev_get_id_vendor (dev);
    }

    int
    get_id_product () {
        return libevdev_get_id_product (dev);
    }

    int
    has_event_type (uint type) {
        return libevdev_has_event_type (dev,type);
    }

    int
    has_event_code (uint type, uint code) {
        return libevdev_has_event_code (dev,type,code);
    }
}


struct
Evdev_event {
    input_event ev;

    const(char)* 
    type_get_name () {
        return libevdev_event_type_get_name (ev.type);
    }

    const(char)* 
    code_get_name () {
        return libevdev_event_code_get_name (ev.type, ev.code);
    }
}

struct
Evdev_fd {
    Fd fd;

    void
    read (Evdev_event* udev_event) {
        .read (cast(int)fd, udev_event, Evdev_event.sizeof);
    }
}
