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
        open_audio_device ();
        open_audio_resources ();
    }

    void
    close () {
        // Clean up
        close_audio_device ();
        close_audio_resources ();
        SDL_Quit ();        
    }

    void
    open_audio_resources () {
        resources[0].filename = cast (char*) "resources/test.wav";
        resources[1].filename = cast (char*) "resources/test-1.wav";
        resources[2].filename = cast (char*) "resources/test-2.wav";
        resources[3].filename = cast (char*) "resources/test-3.wav";

        foreach (ref res; resources)
            res.open ();
    }

    void
    open_audio_device () {
        // Инициализация SDL_mixer с параметрами аудио
        if (Mix_OpenAudio (44100, MIX_DEFAULT_FORMAT, 2, 256) == -1) {
            printf ("Can't init SDL_mixer: %s\n", Mix_GetError ());
            SDL_Quit ();
            abort ();
        }
    }

    void
    close_audio_device () {
        Mix_CloseAudio ();
    }

    void
    close_audio_resources () {
        foreach (ref res; resources)
            res.close ();
    }

    void
    play_wav (int resource_id) {
        Mix_PlayChannel (-1, resources[resource_id].sound, 0);
    }
}

struct
Audion_resource {
    char*         filename = cast (char*) "resources/test.wav";
    SDL_AudioSpec wavSpec;
    Uint32        wavLength;
    Uint8*        wavBuffer;
    Mix_Chunk*    sound;

    void
    open () {
        // Load WAV file
        if (filename !is null) {
            sound = Mix_LoadWAV (filename);
            if (!sound) {
                printf ("Can't cload wav file: %s\n", Mix_GetError ());
                Mix_CloseAudio ();
                SDL_Quit ();
                abort ();
            }
        }
     }

    void
    close () {
        Mix_FreeChunk (sound);
    }
}

void 
init_sdl () {
    if (SDL_Init (SDL_INIT_AUDIO) < 0) {
        printf ("Failed to initialize SDL audio: %s\n", SDL_GetError ());
        abort ();
    }
}

alias Mix_GetError = SDL_GetError;
enum MIX_DEFAULT_FORMAT = AUDIO_S16SYS;
enum AUDIO_S16SYS = AUDIO_S16LSB;
enum AUDIO_S16LSB = 0x8010;
