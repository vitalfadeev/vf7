module vf.audio;

import core.stdc.stdio  : printf;
import core.stdc.stdlib : abort;
import importc;


struct
Audio {
    SDL_AudioDeviceID  deviceId;
    Audion_resource[4] resources;

    void
    open () {    
        init_sdl ();
        open_audio_resources ();
    }

    void
    close () {
        // Clean up
        SDL_CloseAudioDevice (deviceId);
        close_audio_resources ();
        SDL_Quit ();        
    }

    void
    open_audio_resources () {
        foreach (ref res; resources)
            res.open ();
    }

    void
    close_audio_resources () {
        foreach (ref res; resources)
            res.close ();
    }

    void
    play_wav (int resource_id) {
        with (resources[resource_id]) {
            // Open audio device
            deviceId = SDL_OpenAudioDevice (null, 0, &wavSpec, null, 0);
            if (deviceId == 0) {
                printf ("Failed to open audio device: %s\n", SDL_GetError ());
                SDL_FreeWAV (wavBuffer);
                SDL_Quit ();
                abort ();
            }

            // Play audio by queuing the buffer and unpausing device
            SDL_QueueAudio (deviceId, wavBuffer, wavLength);
            SDL_PauseAudioDevice (deviceId, 0); // Unpause to start playback
        }
    }
}

struct
Audion_resource {
    char*         filename = cast (char*) "test.wav";
    SDL_AudioSpec wavSpec;
    Uint32        wavLength;
    Uint8*        wavBuffer;

    void
    open () {
        if (filename !is null)
        // Load WAV file
        if (SDL_LoadWAV (filename, &wavSpec, &wavBuffer, &wavLength) == null) {
            printf ("Failed to load WAV file: %s\n", SDL_GetError ());
            SDL_Quit ();
            abort ();
        }
    }

    void
    close () {
        SDL_FreeWAV (wavBuffer);
    }
}

void 
init_sdl () {
    if (SDL_Init (SDL_INIT_AUDIO) < 0) {
        printf ("Failed to initialize SDL: %s\n", SDL_GetError ());
        abort ();
    }
}

