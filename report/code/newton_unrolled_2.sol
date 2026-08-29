// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        result := clz(x)
        result := sub(257, result)
        // If
        //
        //      2**(k-1) <= x < 2**k
        //
        // we now have
        //
        //      result == k-1

        result := shl(shr(1, result), 1)
        // If
        //
        //      2**(f-1) <= sqrt(x) < 2**f
        //
        // we now have
        //
        //      result == 2**f

        // Perform the 7 required newton iterations
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))

        result := sub(result, gt(result, div(x, result)))
    }
}
