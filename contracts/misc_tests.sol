// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract MiscTests {

    ////////////////////////////////////////////////////////////////////////
    // Gas tests for initialization
    function initcall(uint256 x, uint256 index) public view {
        if (index == 1) {
            init1call(x);
        } else if (index == 2) {
            init2call(x);
        } else if (index == 3) {
            init3call(x);
        } else if (index == 4) {
            init4call(x);
        } else if (index == 5) {
            init5call(x);
        } else if (index == 6) {
            init6call(x);
        } else if (index == 7) {
            init7call(x);
        } else if (index == 8) {
            init8call(x);
        } else {
            revert("Invalid index");
        }
    }

    function init1call(uint256 x) internal view {
    // Newton1 initialization Original (Unrolled1/While1)
        uint256 g = gasleft();
        uint256 y = init_1(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init2call(uint256 x) internal view {
    // Newton2 initialization Original (Unrolled2/While2)
        uint256 g = gasleft();
        uint256 y = init_2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init3call(uint256 x) internal view {
    // Newton3 initialization Original (While3)
        uint256 g = gasleft();
        uint256 y = init_3(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init4call(uint256 x) internal view {
    // BitLength initialization Variant
        uint256 g = gasleft();
        uint256 y = init_4(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init5call(uint256 x) internal view {
    // Linear initialization Variant
        uint256 g = gasleft();
        uint256 y = init_5(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init6call(uint256 x) internal view {
    // Hyper4 initialization Variant (Unrolled3)
        uint256 g = gasleft();
        uint256 y = init_6(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init7call(uint256 x) internal view {
    // BitLength initialization
        uint256 g = gasleft();
        uint256 y = init_7(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init8call(uint256 x) internal view {
    // Linear initialization
        uint256 g = gasleft();
        uint256 y = init_8(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init_1(uint256 x) internal pure returns (uint256 result) {
        // Unrolled1/While1-asm
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shl(shr(1, result), 1)
        }
    }

    function init_2(uint256 x) internal pure returns (uint256 result) {
        // Unrolled2/While2-asm
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(257, result)
            result := shl(shr(1, result), 1)
        }
    }

    function init_3(uint256 x) internal pure returns (uint256 result) {
        // Unrolled3/While3-asm
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))
        }
    }

    function init_4(uint256 x) internal pure returns (uint256 result) {
        // bitlength-asm
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)

            switch and(result, 1)
            case 1 {
                // bitlength is *even*
                result := shr(4, shl(shr(1, result), 27))
            }
            default {
                // bitlength is *odd*
                result := shr(5, shl(shr(1, result), 39))
            }
        }
    }

    function init_5(uint256 x) internal pure returns (uint256 result) {
        // linear-asm
        assembly ("memory-safe") {
            let e := clz(x)
            e := shr(1, e)
            let m := shl(shl(1, e), x)

            result := shr(252, m)
            result := shl(123, add(14, result))

            result := shr(e, result)
        }
    }

    function init_6(uint256 x) internal pure returns (uint256 result) {
        // hyper4-asm
        assembly ("memory-safe") {
            let e := clz(x)
            e := shr(1, e)
            let m := shl(shl(1, e), x)

            result := shr(252, m)
            result := shl(123, div(512, sub(31, result)))

            result := shr(e, result)
        }
    }

    function init_7(uint256 x) internal pure returns (uint256 result) {
        // lookup4-asm
        assembly ("memory-safe") {
            let e := clz(x)
            e := shr(1, e)
            let m := shl(shl(1, e), x)

            result := shr(252, m)
            result := byte(result, 0x000000001113151617191a1b1c1d1e1f00000000000000000000000000000000)
            result := shl(123, result)

            result := shr(e, result)
        }
    }

    bytes constant lookup_table_8 = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x03\x05\x07\x09\x0b\x0d\x0f\x11\x13\x15\x16\x18\x1a\x1c\x1e\x1f\x21\x23\x25\x27\x28\x2a\x2c\x2d\x2f\x31\x32\x34\x36\x37\x39\x3b\x3c\x3e\x3f\x41\x43\x44\x46\x47\x49\x4b\x4c\x4e\x4f\x51\x52\x54\x55\x57\x58\x5a\x5b\x5d\x5e\x5f\x61\x62\x64\x65\x67\x68\x6a\x6b\x6c\x6e\x6f\x71\x72\x73\x75\x76\x77\x79\x7a\x7b\x7d\x7e\x7f\x81\x82\x83\x85\x86\x87\x89\x8a\x8b\x8d\x8e\x8f\x90\x92\x93\x94\x96\x97\x98\x99\x9b\x9c\x9d\x9e\x9f\xa1\xa2\xa3\xa4\xa6\xa7\xa8\xa9\xaa\xac\xad\xae\xaf\xb0\xb2\xb3\xb4\xb5\xb6\xb7\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff";
    function init_8(uint256 x) internal pure returns (uint256 result) {
        // lookup8-asm
        bytes memory lookup_table = lookup_table_8;
        assembly ("memory-safe") {
            // shift past the first 32 bytes (as these store the array length)
            let data_ptr := add(lookup_table, 0x20)

            let e := clz(x)
            e := shr(1, e)
            let m := shl(shl(1, e), x)

            // the initial approximation
            result := shr(248, m) // get the top 8 bits for lookup index
            let word_ptr := add(data_ptr, result) // shift by lookup index
            let word := mload(word_ptr) // grab 32-byte word
            result := byte(0, word) // get lookup value (at index 0 now)
            result := add(256, result) // add implicit high bit
            result := shl(119, result) // shift

            result := shr(e, result)
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Gas tests for unrolled Newton iterations;
    // each additional unrolled iteration costs 48 gas (90 for while)
    function newtoncall(uint256 x, uint256 index) public view {
        if (index == 0) {
            newton0call(x);
        } else if (index == 1) {
            newton1call(x);
        } else if (index == 2) {
            newton2call(x);
        } else if (index == 3) {
            newton3call(x);
        } else if (index == 4) {
            newton4call(x);
        } else if (index == 5) {
            newton5call(x);
        } else if (index == 6) {
            newton6call(x);
        } else {
            revert("Invalid index");
        }
        console.log();
    }

    function newton0call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_0(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton1call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_1(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton2call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton3call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_3(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton4call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_4(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton5call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_5(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton6call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = newton_6(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function newton_0(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))
        }
    }

    function newton_1(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            result := shr(1, add(result, div(x, result)))
        }
    }

    function newton_2(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
        }
    }

    function newton_3(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
        }
    }

    function newton_4(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
        }
    }

    function newton_5(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
        }
    }

    function newton_6(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
            result := shr(1, add(result, div(x, result)))
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Gas tests for rolled Newton iterations;
    // each additional iteration costs 90 (48 for unrolled)
    function whilecall(uint256 x) public view {
        newton_while_call(x);
        console.log();
    }

    function newton_while_call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_while_2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    ////////////////////////////////////////////////////////////////////////
    // while loop with init 2
    // initialization is smallest power-of-2 > isqrt(x)
    function sqrt_newton_while_2(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(257, result)

            // If
            //
            //      2**(f-1) <= sqrt(x) < 2**f
            // 
            // we now have
            // 
            //      result == 2**f
            result := shl(shr(1, result), 1)

            let xAux := shr(1, add(result, div(x, result)))

            // while loop
            for { } lt(xAux, result) { } {
                result := xAux
                xAux := shr(1, add(result, div(x, result)))
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Gas tests for unrolled Halley iterations;
    // each additional unrolled iteration costs 135 gas
    // (48 gas for each Unrolled Newton iteration)
    function halleycall(uint256 x, uint256 index) public view {
        if (index == 0) {
            halley0call(x);
        } else if (index == 1) {
            halley1call(x);
        } else if (index == 2) {
            halley2call(x);
        } else if (index == 3) {
            halley3call(x);
        } else if (index == 4) {
            halley4call(x);
        } else {
            revert("Invalid index");
        }
        console.log();
    }

    function halley0call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = halley_0(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function halley1call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = halley_1(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function halley2call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = halley_2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function halley3call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = halley_3(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function halley4call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = halley_4(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function halley_0(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))
        }
    }

    function halley_1(uint256 x) internal pure returns (uint256 result) {
        assembly ("memory-safe") {
            result := clz(x)
            result := sub(255, result)
            result := shr(1, shl(shr(1, result), 3))

            let r2 := mul(result, result)
            result := div(mul(result, add(r2, mul(3, x))),
                            add(mul(3, r2), x))
        }
    }

    function halley_2(uint256 x) internal pure returns (uint256 result) {
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
        }
    }

    function halley_3(uint256 x) internal pure returns (uint256 result) {
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
        }
    }

    function halley_4(uint256 x) internal pure returns (uint256 result) {
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
        }
    }
}
