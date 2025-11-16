module vf.udev;

import vf.udev_importc;
import vf.path;

enum string UDEV_MONITOR_NAME = "udev";


struct
Udev {
    udev* _udev;

    @disable this();

    this (Udev b) {
        _udev = udev_new ();
    }

    void
    read (Udev_device* dev) {
        //
    }
}

struct
Udev_device {
    Path
    get_path () {
        return Path ();
    }
}

struct
Udev_monitor {
    udev_monitor* _monitor;

    @disable this();

    this (Udev* _udev) {
        _monitor = udev_monitor_new_from_netlink (_udev._udev, UDEV_MONITOR_NAME);

        if (!_monitor) {
          fprintf (stderr, "udev_monitor_new_from_netlink returned NULL\n");
          exit (EXIT_FAILURE);
        }            
    }
}