// SPDX-License-Identifier: 0BSD
// NOTE: return logic has not been verified.
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        // Here, result stores the "bit length" of x
        result := clz(x)
        result := sub(255, result)
        result := shr(1, shl(shr(1, result), 3))

        let r2 := mul(result, result)
        result := div(mul(result, add(r2, mul(3, x))),
                      add(mul(3, r2), x))
        r2 := mul(result, result)
        result := div(mul(result, add(r2, mul(3, x))),
                      add(mul(3, r2), x))
        r2 := mul(result, result)
        result := div(mul(result, add(r2, mul(3, x))),
                      add(mul(3, r2), x))
        r2 := mul(result, result)
        result := div(mul(result, add(r2, mul(3, x))),
                      add(mul(3, r2), x))

        // TODO: determine correct return logic
        result := sub(result, gt(result, div(x, result)))
    }
}
