module vf.map;

import vf.types;


struct
Map {
    size_t length;
    Rec*   ptr;

    struct
    Rec {
        KEY key;
        GO  go;
    }
}

alias KEY = REG;

//
template 
Map_init (Pairs...) {
    import std.conv : to;
    import vf.map   : _Map_init;

    enum string Map_init = "
        static Map map = {" ~ 
            (Pairs.length/2).to!string ~ ", 
            [\n" ~ _Map_init!(Pairs).result ~ "]
        };

        process_map (o,e,evt,d, &map);
        ";
}

template 
_Map_init (Pairs...) {
    static if (Pairs.length == 0)
    {
        // Базовый случай: пустой набор
        enum result = "No pairs";
    }
    else static if (Pairs.length >= 2)
    {
        alias Key   = Pairs[0];
        alias Value = Pairs[1];

        // Рекурсивно обрабатываем оставшиеся пары
        enum rest = _Map_init!(Pairs[2 .. $]).result;

        enum result = "Map.Rec (" ~ Key.stringof ~ ", " ~ (&Value).stringof ~ ")" ~ (rest == "No pairs" ? "\n" : ",\n" ~ rest);
    }
    else
    {
        static assert(0, "Количество элементов в AliasSeq должно быть чётным - пары ключ-значение");
    }
}

void
process_map (void* o, void* e, REG evt, REG d,  Map* map) {
    auto RCX = map.length;
    auto rec = map.ptr;
    for (; RCX != 0; rec++, RCX--)
        if (evt == rec.key)
            rec.go (o,e,evt,d);
}
