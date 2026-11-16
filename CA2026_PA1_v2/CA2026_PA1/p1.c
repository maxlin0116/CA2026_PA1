/*
 * Problem 1: Optimization Analysis with Compiler Explorer
 * Computer Architecture Fall 2026 - Programming Assignment 1
 */

struct Record {
    char type;
    int val;
};

void process_records(const struct Record *in,
                     int *out,
                     int n,
                     int scale_mode) {
    int acc = 0;
    for (int i = 0; i < n; ++i) {
        acc += in[i].val;
        if (scale_mode == 1) {
            out[i] = acc / 4;
        } else if (scale_mode == 2) {
            out[i] = acc / 10;
        } else {
            out[i] = acc;
        }
    }
}
