#include <stdio.h>
#include <stdint.h>

// Include our GF(2^8) multiplier from P3-1
// (Copied here for standalone testing of P3-2)
uint8_t gf28_mul(uint8_t A, uint8_t B) {
    uint8_t P = 0;
    for (int i = 0; i < 8; i++) {
        if (B & 1) { P = P ^ A; }
        uint8_t msb_is_one = A & 0x80;
        A = A << 1;
        A = A & 0xFF; // Ensure it stays within 8 bits
        if (msb_is_one) { A = A ^ 0x1B; }
        B = B >> 1;
    }
    return P;
}

// -----------------------------------------------------------------------------
// [Helper Function] 8-bit Rotate Left
// -----------------------------------------------------------------------------
// Rotates the 8-bit integer 'x' to the left by 'shift' bits.
// The bits that fall off the left end are appended to the right end.
uint8_t rotl8(uint8_t x, int shift) {
    // 1. (x << shift) & 0xFF: Standard left shift, masked to 8 bits
    // 2. (x >> (8 - shift)): Extracts the bits that "fell off" to put them on the right
    // 3. Combine both parts with bitwise OR (|) to complete the rotation
    return ((x << shift) & 0xFF) | (x >> (8 - shift));
}

// =============================================================================
// Problem 3-2: Tableless AES S-Box Calculation
// =============================================================================
uint8_t aes_sbox_calc(uint8_t x) {
    // -----------------------------------------------------
    // Phase 1: Multiplicative Inversion (y = x^254)
    // -----------------------------------------------------
    uint8_t y = x;
    
    // In GF(2^8), the inverse of 0 is defined as 0. 
    // Since 0 multiplied by anything is 0, we can safely skip the loop if x == 0.
    // If x != 0, we multiply it by itself repeatedly (253 multiplications total).
    if (x != 0) {
        for (int i = 0; i < 253; i++) {
            y = gf28_mul(y, x);
        }
    }
    // Now, 'y' holds the multiplicative inverse (x^254)

    // -----------------------------------------------------
    // Phase 2: Affine Transformation
    // s = y ^ rotl8(y, 1) ^ rotl8(y, 2) ^ rotl8(y, 3) ^ rotl8(y, 4) ^ 0x63
    // -----------------------------------------------------
    uint8_t s = y;
    s = s ^ rotl8(y, 1);
    s = s ^ rotl8(y, 2);
    s = s ^ rotl8(y, 3);
    s = s ^ rotl8(y, 4);
    s = s ^ 0x63;

    return s;
}

// =============================================================================
// Main function (to verify P3-2 logic)
// =============================================================================
int main() {
    // Test Cases for 3-2 from the assignment spec:
    // Input x = 0x53 => S-Box Output = 0xED
    // Input x = 0x00 => S-Box Output = 0x63
    
    uint8_t ans1 = aes_sbox_calc(0x53);
    printf("Test 1 Output: 0x%02X (Expected: 0xED)\n", ans1);

    uint8_t ans2 = aes_sbox_calc(0x00);
    printf("Test 2 Output: 0x%02X (Expected: 0x63)\n", ans2);

    return 0;
}
