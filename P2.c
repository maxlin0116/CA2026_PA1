#include <stdio.h>

// Define the 12-byte node structure as described in the assignment
struct Node {
    int val;
    int left_idx;  // -1 indicates no left child
    int right_idx; // -1 indicates no right child
};

// ==========================================
// Implement your BST Range Sum logic here
// ==========================================
int range_sum_bst(struct Node* node_pool, int root_idx, int low, int high) {
    // Base case: if it's an empty node (-1), return 0
    if (root_idx == -1) {
        return 0;
    }

    int sum = 0;
    struct Node current = node_pool[root_idx];

    if(current.val > high) {
        // Current value is greater than high, search left subtree
        sum += range_sum_bst(node_pool, current.left_idx, low, high);
    } else if(current.val < low) {
        // Current value is less than low, search right subtree
        sum += range_sum_bst(node_pool, current.right_idx, low, high);
    } else {
        // Current value is within the range [low, high]
        sum += current.val;
        sum += range_sum_bst(node_pool, current.left_idx, low, high);
        sum += range_sum_bst(node_pool, current.right_idx, low, high);
    }

    return sum;
}

// ==========================================
// Main function (used to test your logic)
// ==========================================
int main() {
    // Test Case 1: BST: [10, 5, 15, 3, 7, null, 18], low = 7, high = 15 => Expected Output: 32
    // Built using level-order traversal (indices 0~6)
    struct Node pool1[] = {
        {10, 1, 2},   // index 0 (Root)
        {5, 3, 4},    // index 1
        {15, -1, 6},  // index 2 (Right child is 18)
        {3, -1, -1},  // index 3
        {7, -1, -1},  // index 4
        {0, -1, -1},  // index 5 (Dummy padding for 'null')
        {18, -1, -1}  // index 6
    };
    
    int ans1 = range_sum_bst(pool1, 0, 7, 15);
    printf("Test 1 Output: %d (Expected: 32)\n", ans1);

    // Test Case 2: BST: [10, 5, 15, 3, 7, 13, 18, 1, null, 6], low = 6, high = 10 => Expected Output: 23
    struct Node pool2[] = {
        {10, 1, 2},   // index 0 (Root)
        {5, 3, 4},    // index 1
        {15, 5, 6},   // index 2
        {3, 7, -1},   // index 3
        {7, 9, -1},   // index 4
        {13, -1, -1}, // index 5
        {18, -1, -1}, // index 6
        {1, -1, -1},  // index 7
        {0, -1, -1},  // index 8 (null)
        {6, -1, -1}   // index 9
    };

    int ans2 = range_sum_bst(pool2, 0, 6, 10);
    printf("Test 2 Output: %d (Expected: 23)\n", ans2);

    return 0;
}