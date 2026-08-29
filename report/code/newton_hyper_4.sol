// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        let e := clz(x)
        e := shr(1, e)
        let m := shl(shl(1, e), x)

        result := shr(252, m)
        // the initial approximation
        result := shl(123, div(512, sub(31, result)))

        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(e, result)

        result := sub(result, gt(result, div(x, result)))
    }
}
