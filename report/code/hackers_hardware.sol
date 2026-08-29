// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 y) {
    assembly ("memory-safe") {
        // m == 2^254
        let m := shl(254, 1)

        // while (m != 0)
        for { } iszero(iszero(m)) { } {
            let b := or(y, m)
            y := shr(1, y)
            // if (x >= b)
            if iszero(lt(x, b)) {
                x := sub(x, b)
                y := or(y, m)
            }
            m := shr(2, m)
        }
    }
}
