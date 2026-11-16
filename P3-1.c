#include <stdio.h>
#include <stdint.h>

// ==========================================
// Problem 3-1: GF(2^8) Finite Field Multiplier
// Implements Russian Peasant Multiplication
// ==========================================
uint8_t gf28_mul(uint8_t A, uint8_t B) {
    uint8_t P = 0; // Step 1: Initialize product P = 0

    // Step 2: Repeat 8 times
    for (int i = 0; i < 8; i++) {
        
        // 1. If the Least Significant Bit (LSB) of B is 1, XOR A into P
        if (B & 1) {
            P = P ^ A;
        }
        
        // 2. Record if the Most Significant Bit (MSB, 7th bit) of A is 1
        uint8_t msb_is_one = A & 0x80;
        
        // 3. Logical left shift A by 1
        A = A << 1;
        
        // 4. If the MSB of A was 1 before shifting, modulo reduction is needed (XOR with 0x1B)
        if (msb_is_one) {
            A = A ^ 0x1B;
        }
        
        // 5. Logical right shift B by 1 to check the next bit in the next iteration
        B = B >> 1;
    }

    // Step 3: Return P (uint8_t return type automatically truncates to 8 bits)
    return P;
}

// ==========================================
// Main function (to verify the logic)
// ==========================================
int main() {
    // Test Cases for 3-1 from the assignment spec:
    // A = 0x57, B = 0x83 => Output = 0xC1
    // A = 0x57, B = 0x13 => Output = 0xFE
    
    uint8_t ans1 = gf28_mul(0x57, 0x83);
    printf("Test 1 Output: 0x%02X (Expected: 0xC1)\n", ans1);

    uint8_t ans2 = gf28_mul(0x57, 0x13);
    printf("Test 2 Output: 0x%02X (Expected: 0xFE)\n", ans2);

    return 0;
}
