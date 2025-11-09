module vf.bc_array;

import core.stdc.stdlib : malloc,free,realloc;

struct 
Array (T) {
    T*     data;
    size_t length;
    size_t capacity;

    void
    setup (size_t initialCapacity) {
        data     = cast (T*) malloc (initialCapacity * T.sizeof);
        length   = 0;
        capacity = initialCapacity;
    }

    ~this () {
        if (data)
            free (data);
    }

    void 
    add (T value) {
        if (length == capacity) {
            capacity *= 2;
            data = cast (T*) realloc (data, capacity * T.sizeof);
        }
        data[length] = value;
        length++;
    }

    ref T 
    opIndex (size_t i) {
        return data[i];
    }

    T 
    opIndex (size_t i) const {
        return data[i];
    }

    void 
    remove_at (size_t index) {
        assert(index < length);
        // Сдвиг элементов влево
        for (size_t i = index; i + 1 < length; ++i) {
            data[i] = data[i + 1];
        }
        length--;
        // Необязательно: уменьшить capacity через realloc, если нужно
    }
}
