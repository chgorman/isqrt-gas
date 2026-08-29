// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 left) {
    assembly ("memory-safe") {
        // Here, result stores the "bit length" of x
        left := clz(x)
        left := sub(255, left)

        left := shl(shr(1, left), 1)
        let right := shl(1, left)
    
        // iszero(gt(left, right))  is equivalence to
        // left <= right
        for { } iszero(gt(left, right)) { } {
            let midpoint := shr(1, add(left, right))
            switch gt(midpoint, div(x, midpoint))
            case 1 {
                right := sub(midpoint, 1)
            }
            default {
                left := add(midpoint, 1)
            }
        }
        left := sub(left, 1)
    }
}
