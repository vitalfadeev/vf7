module vf.map;

import vf.types;


struct
Map_rec {
    KEY key;
    GO  go;
}

void
process_map (void* o, void* e, REG evt, REG d,  size_t map_length, Map_rec* map_ptr) {
    auto RCX = map_length;
    auto rec = map_ptr;
    for (; RCX != 0; rec++, RCX--)
        if (evt == rec.key)
            rec.go (o,e,evt,d);
}

alias KEY = REG;


//
void
GO_map (Pairs...) (void* o, void* e, REG evt, REG d) {
    alias _array = GO_map_array!Pairs;  // [Rec (Key,Value), ...]
    
    static Map_rec[ _array.length ] map = _array;

    process_map (o,e,evt,d, map.length, map.ptr);
}

template
GO_map_array (Pairs...) {
    enum GO_map_array = [GO_map_array_init!(Pairs).result];
}

template 
GO_map_array_init (Pairs...) {
    import std.meta : AliasSeq;

    static if (Pairs.length == 0)
    {
        // Базовый случай: пустой набор
        enum result = AliasSeq!();
    }
    else static if (Pairs.length >= 2)
    {
        alias Key   = Pairs[0];
        alias Value = Pairs[1];

        // Рекурсивно обрабатываем оставшиеся пары
        enum rest   = GO_map_array_init!(Pairs[2 .. $]).result;
        enum result = AliasSeq!(Map_rec (Key,&Value), rest);
    }
    else
    {
        static assert(0, "Количество элементов в AliasSeq должно быть чётным - пары ключ-значение");
    }
}

