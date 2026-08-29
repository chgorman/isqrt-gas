// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 left) {
   unchecked {
        if (x == 0) {
            return 0;
        }
        if (x < 16) {
            if (x < 4) {
                return 1;
            } else if (x < 9) {
                return 2;
            } else {
                return 3;
            }
        }
        assembly ("memory-safe") {
            left := clz(x)
            left := sub(255, left)
            left := shl(shr(1, left), 1)
            let right := shl(1, left)

            for { } and(iszero(gt(left, div(x, left))),
                        lt(div(x, right), right)) { } {
                let interp := add(left,
                                  div(sub(x, mul(left, left)),
                                      add(right, left)))

                switch lt(div(x, interp), interp)
                case 1 {
                    right := interp
                }
                default {
                    left := add(interp, 1)
                }
            }
            left := sub(left, 1)
        }
    }
}
