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
    function sqrt_halley(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
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

            // TODO: determine correct return logic
            if (result <= x/result) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Method for computing integer square roots used in Python
    function sqrt_python(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            if (x >= ((1 << 128) - 1)**2) {
                return (1 << 128) - 1;
            }
            // Here, e represents the bit length;
            // its value is at most 256, so it could fit in a uint16.
            uint256 e = 1;
            // Here, result is a copy of x to compute the bit length
            uint256 result = x;
            if (result >= (1 << 128)) {
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
                e += 1;
            }
            // e is currently bit length; we overwrite it to scale x
            e = (256 - e) >> 1;
            // m now satisfies 2**254 <= m < 2**256
            uint256 m = x << (2 * e);
            // result now stores the result
            result = 1 + (m >> 254);
            result = (result << 1) + (m >> 251) / result;
            result = (result << 3) + (m >> 245) / result;
            result = (result << 7) + (m >> 233) / result;
            result = (result << 15) + (m >> 209) / result;
            result = (result << 31) + (m >> 161) / result;
            result = (result << 63) + (m >> 65) / result;
            result >>= e;
            if (result * result <= x) {
                return result;
            }
            return result-1;
        }
    }


    ////////////////////////////////////////////////////////////////////////
    // Binary search bounding isqrt by powers-of-2; based on Hacker's Delight
    function sqrt_binary_search(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            uint256 xAux = x;
            uint256 left = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                left = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                left <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                left <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                left <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                left <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                left <<= 2;
            }
            if (xAux >= (1 << 2)) {
                left <<= 1;
            }
            uint256 right = left << 1;
            uint256 midpoint;
            while (left <= right) {
                midpoint = (left + right) >> 1;
                if (midpoint > x/midpoint) {
                    right = midpoint - 1;
                } else {
                    left = midpoint + 1;
                }
            }
            return left-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Interpolation search bounding isqrt by powers-of-2
    function sqrt_interp_search(uint256 x) internal pure returns (uint256) {
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
            uint256 xAux = x;
            uint256 left = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                left = 1 << 64;
            }
            if (xAux >= (1 << 64)) {
                xAux >>= 64;
                left <<= 32;
            }
            if (xAux >= (1 << 32)) {
                xAux >>= 32;
                left <<= 16;
            }
            if (xAux >= (1 << 16)) {
                xAux >>= 16;
                left <<= 8;
            }
            if (xAux >= (1 << 8)) {
                xAux >>= 8;
                left <<= 4;
            }
            if (xAux >= (1 << 4)) {
                xAux >>= 4;
                left <<= 2;
            }
            if (xAux >= (1 << 2)) {
                left <<= 1;
            }
            uint256 right = (left << 1);
            uint256 interp;
            while ((left <= x/left) && (x/right < right)) {
                interp = left + (x - left**2)/(right + left);
                if (x/interp < interp) {
                    right = interp;
                } else {
                    left = interp + 1;
                }
            }
            return left-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Hardware algorithm from Hacker's Delight
    function sqrt_hardware(uint256 x) internal pure returns (uint256) {
        unchecked {
            uint256 m = 2**254;
            uint256 y = 0;
            uint256 b = 0;

            while (m != 0) {
                b = y | m;
                y = y >> 1;
                if (x >= b) {
                    x = x - b;
                    y = y | m;
                }
                m = m >> 2;
            }
            return y;
        }
    }
}
