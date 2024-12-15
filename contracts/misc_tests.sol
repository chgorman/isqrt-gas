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
        } else if (index == 9) {
            init9call(x);
        } else if (index == 10) {
            init10call(x);
        } else if (index == 11) {
            init11call(x);
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
    // Newton1 initialization Variant
        uint256 g = gasleft();
        uint256 y = init_4(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init5call(uint256 x) internal view {
    // Newton2 initialization Variant
        uint256 g = gasleft();
        uint256 y = init_5(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init6call(uint256 x) internal view {
    // Newton3 initialization Variant (Unrolled3)
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

    function init9call(uint256 x) internal view {
    // Hyper4 initialization
        uint256 g = gasleft();
        uint256 y = init_9(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init10call(uint256 x) internal view {
    // Hyper4 initialization
        uint256 g = gasleft();
        uint256 y = init_10(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init11call(uint256 x) internal view {
    // Hyper4 initialization
        uint256 g = gasleft();
        uint256 y = init_11(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function init_1(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            return result;
        }
    }

    function init_2(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 2;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 2 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            return result;
        }
    }

    function init_3(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            return result;
        }
    }

    function init_4(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            result = 1 << (e/2);
            return result;
        }
    }

    function init_5(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 2;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 130;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            result = 1 << (e/2);
            return result;
        }
    }

    function init_6(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            result = (3 << (e/2)) >> 1;
            return result;
        }
    }

    function init_7(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                result >>= 2;
                e += 2;
            }
            if (result >= (1 << 1)) {
                result = (27 << (e/2)) >> 4;
            } else {
                result = (39 << (e/2)) >> 5;
            }
            return result;
        }
    }

    function init_8(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            e = (256 - e) >> 1;
            uint256 m = x << (2 * e);
            result = m >> 252;
            result = (14 + result) << 123;
            result >>= e;
            return result;
        }
    }

    function init_9(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            e = (256 - e) >> 1;
            uint256 m = x << (2 * e);
            result = m >> 252;
            result = (512/(31 - result)) << 123;
            result >>= e;
            return result;
        }
    }

    bytes constant lookup_table_4 = "\x00\x00\x00\x00\x11\x13\x15\x16\x17\x19\x1a\x1b\x1c\x1d\x1e\x1f";
    function init_10(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            e = (256 - e) >> 1;
            uint256 m = x << (2 * e);
            result = uint256(uint8(lookup_table_4[(m >> 252)])) << 123;
            result >>= e;
            return result;
        }
    }

    bytes constant lookup_table_8 = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x03\x05\x07\x09\x0b\x0d\x0f\x11\x13\x15\x16\x18\x1a\x1c\x1e\x1f\x21\x23\x25\x27\x28\x2a\x2c\x2d\x2f\x31\x32\x34\x36\x37\x39\x3b\x3c\x3e\x3f\x41\x43\x44\x46\x47\x49\x4b\x4c\x4e\x4f\x51\x52\x54\x55\x57\x58\x5a\x5b\x5d\x5e\x5f\x61\x62\x64\x65\x67\x68\x6a\x6b\x6c\x6e\x6f\x71\x72\x73\x75\x76\x77\x79\x7a\x7b\x7d\x7e\x7f\x81\x82\x83\x85\x86\x87\x89\x8a\x8b\x8d\x8e\x8f\x90\x92\x93\x94\x96\x97\x98\x99\x9b\x9c\x9d\x9e\x9f\xa1\xa2\xa3\xa4\xa6\xa7\xa8\xa9\xaa\xac\xad\xae\xaf\xb0\xb2\xb3\xb4\xb5\xb6\xb7\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff";
    function init_11(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 result = x;
            uint256 e = 1;
            if (x >= (1 << 128)) {
                result >>= 128;
                e = 129;
            }
            if (result >= (1 << 64)) {
                result >>= 64;
                e += 64;
            }
            if (result >= (1 << 32)) {
                result >>= 32;
                e += 32;
            }
            if (result >= (1 << 16)) {
                result >>= 16;
                e += 16;
            }
            if (result >= (1 << 8)) {
                result >>= 8;
                e += 8;
            }
            if (result >= (1 << 4)) {
                result >>= 4;
                e += 4;
            }
            if (result >= (1 << 2)) {
                e += 2;
            }
            e = (256 - e) >> 1;
            uint256 m = x << (2 * e);
            result = 2**127 + (uint256(uint8(lookup_table_8[(m >> 248)])) << 119);
            result >>= e;
            return result;
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

    function newton_0(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            return result;
        }
    }

    function newton_1(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result + x / result) >> 1;
            return result;
        }
    }

    function newton_2(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            return result;
        }
    }

    function newton_3(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            return result;
        }
    }

    function newton_4(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            return result;
        }
    }

    function newton_5(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            return result;
        }
    }

    function newton_6(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            return result;
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
    function sqrt_newton_while_2(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            uint256 xAux = x;
            uint256 result = 2;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 2 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }

            xAux = (result + x / result) >> 1;
            while (xAux < result) {
                result = xAux;
                xAux = (result + x / result) >> 1;
            }
            return result;
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

    function halley_0(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            return result;
        }
    }

    function halley_1(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            return result;
        }
    }

    function halley_2(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            return result;
        }
    }

    function halley_3(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            return result;
        }
    }

    function halley_4(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                result <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                result <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                result <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                result <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                result <<= 2;
            }
            if (xAux >= (1 << 2)) {
                result <<= 1;
            }
            result = (3*result) >> 1;
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            result = (result * (result**2 + 3 * x))/(3 * result**2 + x);
            return result;
        }
    }
}
