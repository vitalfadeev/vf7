#undef SDL_DEPRECATED
#define SDL_DEPRECATED

#define SDL_DISABLE_IMMINTRIN_H
#define SDL_DISABLE_MMINTRIN_H
#define SDL_DISABLE_XMMINTRIN_H
#define SDL_DISABLE_EMMINTRIN_H

#include "SDL.h"
#include "SDL_mixer.h"

#include <libudev.h>
#undef __SIZEOF_INT128__
#include <linux/input.h>
#ifndef EV_SYN
#define EV_SYN 0
#endif
