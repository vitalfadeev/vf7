module vf.video;

import core.stdc.stdio  : printf;
import core.stdc.stdlib : abort;
import importc;


struct
Video {
    void
    open () {    
        if (SDL_Init (SDL_INIT_VIDEO) < 0) {
            printf ("Failed to initialize SDL video: %s\n", SDL_GetError ());
            abort ();
        }
    }

    void
    close () {
        //SDL_Quit ();        
    }
}
