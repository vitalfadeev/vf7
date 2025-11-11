module vf.bc_stubs;

version (D_BetterC):
// _d_assertp
extern(C) 
void 
__assert (const(char)* msg, const(char)* file, int line) {
    import core.stdc.stdio  : fprintf,stderr;
    import core.stdc.stdlib : exit;
    fprintf (stderr, "Assertion failed: %s, file %s, line %d\n", msg, file, line);
    // Здесь можно добавить завершение программы или другое поведение
    exit (1);
}

extern(C) 
void 
_d_assertp (const(char)* file, uint line) {
    import core.stdc.stdio  : printf;
    import core.stdc.stdlib : abort;

    printf ("Assertion failed at %s:%u\n", file, line);
    abort ();
}

extern(C) 
void 
_d_assert_msg (bool condition, string expr, string file, size_t line) {
    import core.stdc.stdio  : printf;
    import core.stdc.stdlib : exit;

    if (!condition) {
        //printf ("Assertion failed: ", expr, "\nFile: ", file, "\nLine: ", line);
        printf ("Assertion failed: ");
        exit (1);
    }
}


extern(C) 
void 
_d_dso_registry () {
    // Пустая функция-заглушка для подавления ошибок линковки
    // В режиме betterC нет полноценного runtime, поэтому просто ничего не делать
}
