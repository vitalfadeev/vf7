module vf.input;

import core.sys.posix.unistd   : read, close;
import core.sys.posix.fcntl    : open, O_RDONLY, O_NONBLOCK;
import core.sys.posix.sys.time : timeval;
import vf.types                : REG;
import vf.key_codes;

import importc;
import core.sys.posix.sys.stat : stat,stat_t;
import core.stdc.errno         : errno;
import core.bitop              : bts,bt;
//import core.sys.posix.sys.ioctl;
//import vf.core.sys.linux.input;


enum EVIOCGID  = _IOR('E', 0x02, input_id.sizeof);       /* get device ID */
enum EVIOCGREP = _IOR('E', 0x03, uint[2].sizeof);        /* get repeat settings */
enum EVIOCSREP = _IOW('E', 0x03, uint[2].sizeof);        /* set repeat settings */

enum _IOC (alias dir, alias type, alias nr, alias size) = 
    (
        ((dir)  << _IOC_DIRSHIFT) | 
        ((type) << _IOC_TYPESHIFT) | 
        ((nr)   << _IOC_NRSHIFT) | 
        ((size) << _IOC_SIZESHIFT)
    );

enum EVIOCGNAME (alias len) = _IOC!(_IOC_READ, 'E', 0x06, len); /* get device name */
enum EVIOCGPHYS (alias len) = _IOC!(_IOC_READ, 'E', 0x07, len); /* get physical location */
enum EVIOCGUNIQ (alias len) = _IOC!(_IOC_READ, 'E', 0x08, len); /* get unique identifier */
enum EVIOCGPROP (alias len) = _IOC!(_IOC_READ, 'E', 0x09, len); /* get device properties */


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

struct
Devices {
    int 
    list_via_udev () {
        udev* udev = udev_new ();
        udev_enumerate* enumerate = udev_enumerate_new (udev);
        udev_enumerate_add_match_subsystem (enumerate, "input");
        udev_enumerate_scan_devices (enumerate);

        udev_list_entry* devices = udev_enumerate_get_list_entry (enumerate);
        udev_list_entry* dev_list_entry;
        stat_t           statbuf;

        for (dev_list_entry  = devices; 
             dev_list_entry != null;
             dev_list_entry  = udev_list_entry_get_next (dev_list_entry)) 
        {
            const char*  path    = udev_list_entry_get_name (dev_list_entry);
            udev_device* dev     = udev_device_new_from_syspath (udev, path);
            const char*  devnode = udev_device_get_devnode (dev);

            if (devnode) {
                printf ("Input device: %s\n", devnode);

                if (stat (devnode, &statbuf) != 0)
                    continue;
                auto fd = device_open (devnode, /* verbose */ 0);
                if (-1 == fd)
                    continue;
                //device_info (devnode, fd, /* verbose */ 0);
                close (fd);
            }
            udev_device_unref (dev);
        }

        udev_enumerate_unref (enumerate);
        udev_unref (udev);

        return 0;
    }

    int 
    device_open (const char* filename, int verbose) {
        int fd;

        fd = open (filename,O_RDONLY);
        if (-1 == fd) {
            fprintf (stderr,"open %s: %s\n",
                filename, strerror (errno));
            return -1;
        }
        if (verbose)
            printf ("%s\n",filename);

        return fd;
    }
}


import vf.fd;

struct
Fds {
   Fd[] s; 

   void
   poll () {
       //
   }

   void
   select () {
       //
   }

   //
   void
   add (Fd fd) {
       //
   }

   void
   remove (Fd fd) {
       //
   }
}

struct
Event_selector {
    Fd[] fds;

    struct
    Rec {
        Fd fd;
        DG dg;
    }

    alias DG = void delegate ();
}

void
__go () {
    Udev  udev;
    Evdev evdev1;
    input_event[3] input_event_pack1;
    Evdev evdev2;
    input_event[3] input_event_pack2;
    Evdev evdev3;
    input_event[3] input_event_pack3;

    void
    read_event_pack () {
        //
    }

    void
    select () {
        FDSET fds;

        // udev
        fds[0] = udev.fd;

        // evdev
        fds[1] = evdev.fd;

        //
        select (fds);

        //
        if (event.type = EV_SYN) {
            // read pack
        }
    }
}

