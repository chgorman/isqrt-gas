// SPDX-License-Identifier: MIT
function sqrt(uint256 x) pure returns (uint256 result) {
    unchecked {
        result = 1 << (msb(x) >> 1);
    }

    assembly ("memory-safe") {
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

function msb(uint256 x) pure returns (uint256 result) {
    assembly ("memory-safe") {
        result := shl(7, lt(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, x))
        result := or(result, shl(6, lt(0xFFFFFFFFFFFFFFFF,
                                       shr(result, x))))
        result := or(result, shl(5, lt(0xFFFFFFFF,
                                       shr(result, x))))
        result := or(result, shl(4, lt(0xFFFF, shr(result, x))))
        result := or(result, shl(3, lt(0xFF, shr(result, x))))
        result := or(result, shl(2, lt(0xF, shr(result, x))))
        result := or(result, shl(1, lt(0x3, shr(result, x))))
        result := or(result, lt(0x1, shr(result, x)))
    }
}
