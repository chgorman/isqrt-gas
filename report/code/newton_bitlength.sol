// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        result := clz(x)
        result := sub(255, result)
        // If
        //
        //      2**(k-1) <= x < 2**k
        //
        // we now have
        //
        //      result == k-1
        //
        // Thus, we actually are using the bitlength minus one

        switch and(result, 1)
        case 1 {
            // bitlength is *even*
            result := shr(4, shl(shr(1, result), 27))
        }
        default {
            // bitlength is *odd*
            result := shr(5, shl(shr(1, result), 39))
        }

        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))

        result := sub(result, gt(result, div(x, result)))
    }
}
