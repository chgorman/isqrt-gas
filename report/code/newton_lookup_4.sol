// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        let e := clz(x)
        e := shr(1, e)
        let m := shl(shl(1, e), x)

        // the initial approximation
        result := shr(252, m) // get the top 4 bits for lookup
        result := byte(result,
                       0x000000001113151617191a1b1c1d1e1f
                         00000000000000000000000000000000)
        result := shl(123, result)

        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(e, result)

        result := sub(result, gt(result, div(x, result)))
    }
}
