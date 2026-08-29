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

        result := shr(1, shl(shr(1, result), 3))
        // If
        //
        //      2**(f-1) <= sqrt(x) < 2**f
        //
        // we now have
        //
        //      result == 2**(f-1) + 2**(f-2)

        result := shr(1, add(result, div(x, result)))
        let xAux := shr(1, add(result, div(x, result)))

        // while loop
        for { } lt(xAux, result) { } {
            result := xAux
            xAux := shr(1, add(result, div(x, result)))
        }
    }
}
