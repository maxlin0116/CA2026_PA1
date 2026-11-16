#include <stdio.h>

// =============================================================================
// Problem 4: Character Frequency Counter
// Task: Count occurrences of each character and output in ASCII alphabetical order.
// Example: "AABBAA" -> "4A2B"
// =============================================================================

// Helper function: Convert an integer to string characters and write to the output array.
// To achieve the 10% hidden bonus (no RV32M div/rem instructions),
// we use "Repeated Subtraction" to calculate the hundreds, tens, and units digits!
// Since the max string length is 200, the maximum count is 200 (at most 3 digits).
char* int_to_string_no_div(int count, char* out) {
    int hundreds = 0;
    int tens = 0;
    int ones = 0;

    // 1. Calculate hundreds digit (repeatedly subtract 100)
    while (count >= 100) {
        count -= 100;
        hundreds++;
    }

    // 2. Calculate tens digit (repeatedly subtract 10)
    while (count >= 10) {
        count -= 10;
        tens++;
    }

    // 3. The remainder is the units digit
    ones = count;

    // 4. Convert digits to characters (ASCII for '0' is 48)
    // Only print the hundreds digit if it's greater than 0
    if (hundreds > 0) {
        *out = hundreds + '0';
        out++;
    }
    
    // Print tens digit if hundreds > 0 OR tens > 0 (e.g., for 105, we must print '0')
    if (hundreds > 0 || tens > 0) {
        *out = tens + '0';
        out++;
    }
    
    // The units digit is always printed
    *out = ones + '0';
    out++;

    return out; // Return the updated pointer
}

// Main task function
void freq_count(const char* in, char* out) {
    // 1. Prepare an array of size 128 to record the frequency of each ASCII character.
    // In assembly, this is typically allocated on the Stack (sp) as 128 bytes or 128 words.
    int counts[128] = {0};

    // 2. Read the input string and count occurrences
    const char* ptr = in;
    while (*ptr != '\0') {
        int ascii_val = (int)(*ptr);
        counts[ascii_val]++; // Increment the count for the corresponding character
        ptr++;
    }

    // 3. Output results in ASCII order (from 32 to 126)
    char* out_ptr = out;
    for (int i = 32; i <= 126; i++) {
        if (counts[i] > 0) {
            // (a) Convert count to string and write to output
            out_ptr = int_to_string_no_div(counts[i], out_ptr);
            
            // (b) Write the character itself to output
            *out_ptr = (char)i;
            out_ptr++;
        }
    }

    // 4. Append the null-terminator ('\0') at the very end
    *out_ptr = '\0';
}

// =============================================================================
// Test cases (same as the assignment spec)
// =============================================================================
int main() {
    char out_buf1[256];
    freq_count("AABBAA", out_buf1);
    printf("Test 1: \"%s\" (Expected: 4A2B)\n", out_buf1);

    char out_buf2[256];
    freq_count("  hello  ", out_buf2);
    printf("Test 2: \"%s\" (Expected: 4 1e1h2l1o)\n", out_buf2);

    return 0;
}
