module vf.key_codes;

import vf.input_event_codes;

enum       EVT_KEY                   = (0             << 16) | EV_KEY;
enum       EVT_REL                   = (0             << 16) | EV_REL;
enum       EVT_SYN                   = (0             << 16) | EV_SYN;

enum       EVT_KEY_A                 = (KEY_A         << 16) | EVT_KEY;
enum       EVT_KEY_B                 = (KEY_B         << 16) | EVT_KEY;
enum       EVT_KEY_C                 = (KEY_C         << 16) | EVT_KEY;
enum       EVT_KEY_Q                 = (KEY_Q         << 16) | EVT_KEY;
enum       EVT_KEY_W                 = (KEY_W         << 16) | EVT_KEY;
enum       EVT_KEY_E                 = (KEY_E         << 16) | EVT_KEY;
enum       EVT_KEY_ESC               = (KEY_ESC       << 16) | EVT_KEY;
enum       EVT_KEY_LEFTCTRL          = (KEY_LEFTCTRL  << 16) | EVT_KEY;
enum       EVT_KEY_RIGHTCTRL         = (KEY_RIGHTCTRL << 16) | EVT_KEY;

enum ulong EVT_KEY_PRESSED           = 1;
enum ulong EVT_KEY_RELEASED          = 0;

enum ulong EVT_KEY_A_PRESSED         = (EVT_KEY_PRESSED   << 32) | EVT_KEY_A;
enum ulong EVT_KEY_A_RELEASED        = (EVT_KEY_RELEASED  << 32) | EVT_KEY_A;
enum ulong EVT_KEY_B_PRESSED         = (EVT_KEY_PRESSED   << 32) | EVT_KEY_B;
enum ulong EVT_KEY_C_PRESSED         = (EVT_KEY_PRESSED   << 32) | EVT_KEY_C;
enum ulong EVT_KEY_Q_PRESSED         = (EVT_KEY_PRESSED   << 32) | EVT_KEY_Q;
enum ulong EVT_KEY_W_PRESSED         = (EVT_KEY_PRESSED   << 32) | EVT_KEY_W;
enum ulong EVT_KEY_E_PRESSED         = (EVT_KEY_PRESSED   << 32) | EVT_KEY_E;
enum ulong EVT_KEY_ESC_PRESSED       = (EVT_KEY_PRESSED   << 32) | EVT_KEY_ESC;
enum ulong EVT_KEY_LEFTCTRL_PRESSED  = (EVT_KEY_PRESSED   << 32) | EVT_KEY_LEFTCTRL;
enum ulong EVT_KEY_LEFTCTRL_RELEASED = (EVT_KEY_RELEASED  << 32) | EVT_KEY_LEFTCTRL;

//
enum ulong EVT_REL_MOVED             = (0) | EVT_REL;

enum       EVT_UI                    = 0x0200;
enum ulong UI_POINTER_IN             = (2     << 16) | EVT_UI;;
enum ulong UI_POINTER_OVER           = (3     << 16) | EVT_UI;;
enum ulong UI_POINTER_OUT            = (4     << 16) | EVT_UI;;

enum       EVT_APP                   = 0x0100;
enum       APP_CODE_QUIT             = 0x0001;
enum ulong EVT_APP_QUIT              = (APP_CODE_QUIT     << 16) | EVT_APP;

