module vf.fd;

import vf.fd_importc;


struct
Fd {
    int fd;

    //void
    //open (char* filename) {
    //    fd = .open ();
    //}

    void
    close () {
        .close (fd);
    }

    void
    read (ubyte* bytes, size_t size) {
        .read (fd, bytes, size);
    }

    int
    opCast (T : int) () {
        return fd;
    }
}
