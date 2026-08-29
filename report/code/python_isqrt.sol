// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        let e := clz(x)
        e := shr(1, e)
        let m := shl(shl(1, e), x)

        result := add(1, shr(254, m))
        result := add(shl(1,  result), div(shr(251, m), result))
        result := add(shl(3,  result), div(shr(245, m), result))
        result := add(shl(7,  result), div(shr(233, m), result))
        result := add(shl(15, result), div(shr(209, m), result))
        result := add(shl(31, result), div(shr(161, m), result))
        result := add(shl(63, result), div(shr(65, m), result))
        result := shr(e, result)

        result := sub(result, gt(result, div(x, result)))
    }
}
