// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.20;

// Import this file to use console.log
import "hardhat/console.sol";

contract SqrtTestsOther {

    // These algorithms are all methods not based on Newton's method.
    function sqrtcall(uint256 x, uint256 index) public view {
        if (index == 1) {
            sqrt1call(x);
        } else if (index == 2) {
            sqrt2call(x);
        } else if (index == 3) {
            sqrt3call(x);
        } else if (index == 4) {
            sqrt4call(x);
        } else {
            revert("Invalid index");
        }
    }

    // For testing purposes
    function sqrt_test(uint256 x) public view {
        uint256 g = gasleft();
        uint256 y = sqrt_tmp_test(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt1call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_binary_search(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt2call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_interp_search(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt3call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_hardware(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt4call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_python(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt_binary_search_call(uint256 x) public view {
        uint256 g = gasleft();
        uint256 y = sqrt_binary_search(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt_interp_search_call(uint256 x) public view {
        uint256 g = gasleft();
        uint256 y = sqrt_interp_search(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function halleycall(uint256 x) public view {
        uint256 g = gasleft();
        uint256 y = sqrt_halley(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    ////////////////////////////////////////////////////////////////////////
    // Halley's method for computing square roots;
    // higher-order version of Newton's method;
    // same initialization as Unrolled3.
    // NOTE: return logic has not been verified.
    function sqrt_halley(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
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

    ////////////////////////////////////////////////////////////////////////
    // Method for computing integer square roots used in Python
    function sqrt_python(uint256 x) internal pure returns (uint256 result) {
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
            result := add(shl(63, result), div(shr(65,  m), result))
            result := shr(e, result)

            result := sub(result, gt(result, div(x, result)))
        }
    }


    ////////////////////////////////////////////////////////////////////////
    // Binary search bounding isqrt by powers-of-2; based on Hacker's Delight
    function sqrt_binary_search(uint256 x) internal pure returns (uint256 left) {
        assembly ("memory-safe") {
            left := clz(x)
            left := sub(255, left)

            left := shl(shr(1, left), 1)
            let right := shl(1, left)
        
            for { } iszero(gt(left, right)) { } {
                let midpoint := shr(1, add(left, right))
                switch gt(midpoint, div(x, midpoint))
                case 1 {
                    right := sub(midpoint, 1)
                }
                default {
                    left := add(midpoint, 1)
                }
            }
            left := sub(left, 1)
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Interpolation search bounding isqrt by powers-of-2
    function sqrt_interp_search(uint256 x) internal pure returns (uint256 left) {
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

                for { } and(iszero(gt(left, div(x, left))), lt(div(x, right), right)) { } {
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

    ////////////////////////////////////////////////////////////////////////
    // Hardware algorithm from Hacker's Delight
    function sqrt_hardware(uint256 x) internal pure returns (uint256 y) {
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

    ////////////////////////////////////////////////////////////////////////
    // For testing
    function sqrt_tmp_test(uint256 x) internal pure returns (uint256 left) {
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

                for { } and(iszero(gt(left, div(x, left))), lt(div(x, right), right)) { } {
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
}
