module vf.map;

import vf.types;

struct
Map {
    Rec[] recs;

    struct
    Rec {
        KEY key;
        GO  go;
    }
}

alias KEY = REG;


//void 
//Default_go (void* o, void* e, REG c, REG d) {
//    //
//};

//struct
//Act {
//    string name;
//    GO     go      = &Default_go;
//    GO     go_back = &Default_go;
//}

//struct
//Map {
//    Rec[] recs;

//    struct
//    Rec {
//        KEY  key;
//        Act* act;
//    }
//}

//alias KEY = REG;
