module vf.path;

import vf.fd;


struct
Path {
    char* path;

    Fd
    open () {
        return Fd ();
    }
}
