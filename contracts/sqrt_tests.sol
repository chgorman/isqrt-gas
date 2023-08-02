// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract SqrtTests {

    function sqrtcall(uint256 x, uint256 index) public view {
        if (index == 1) {
            sqrt1call(x);
        } else if (index == 2) {
            sqrt2call(x);
        } else if (index == 3) {
            sqrt3call(x);
        } else if (index == 4) {
            sqrt4call(x);
        } else if (index == 5) {
            sqrt5call(x);
        } else if (index == 6) {
            sqrt6call(x);
        } else if (index == 7) {
            sqrt7call(x);
        } else if (index == 8) {
            sqrt8call(x);
        } else if (index == 9) {
            sqrt9call(x);
        } else if (index == 10) {
            sqrt10call(x);
        } else if (index == 11) {
            sqrt11call(x);
        } else {
            revert("Invalid index");
        }
    }

    function sqrt1call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_uni_v2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt2call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_prb(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt3call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_oz(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt4call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_abdk(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt5call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_python(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt6call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_unrolled_1(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt7call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_unrolled_2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt8call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_unrolled_3(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt9call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_while_1(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt10call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_while_2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    function sqrt11call(uint256 x) internal view {
        uint256 g = gasleft();
        uint256 y = sqrt_newton_while_3(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }

    ////////////////////////////////////////////////////////////////////////
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
                e += 128;
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
    // initialization is largest power-of-2 <= isqrt(x)
    function sqrt_newton_unrolled_1(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            if (x >= ((1 << 128) - 1)**2) {
                return (1 << 128) - 1;
            }
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result <<= 64;
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
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result * result <= x) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // initialization is smallest power-of-2 > isqrt(x)
    function sqrt_newton_unrolled_2(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            if (x >= ((1 << 128) - 1)**2) {
                return (1 << 128) - 1;
            }
            uint256 xAux = x;
            uint256 result = 2;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result <<= 64;
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
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result * result <= x) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Original design
    // initialization with better approximation
    function sqrt_newton_unrolled_3(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            if (x >= ((1 << 128) - 1)**2) {
                return (1 << 128) - 1;
            }
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result <<= 64;
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
            result += (result >> 1);
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result * result <= x) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // while loop with init 1
    // initialization is largest power-of-2 <= isqrt(x)
    function sqrt_newton_while_1(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result <<= 64;
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
            result = xAux;
            xAux = (result + x / result) >> 1;
            while (xAux < result) {
                result = xAux;
                xAux = (result + x / result) >> 1;
            }
            return result;
        }
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
                result <<= 64;
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
    // while loop with init 3
    // initialization with better approximation
    function sqrt_newton_while_3(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
            uint256 xAux = x;
            uint256 result = 1;
            if (xAux >= (1 << 128)) {
                xAux >>= 128;
                result <<= 64;
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
            result += (result >> 1);

            xAux = (result + x / result) >> 1;
            result = xAux;
            xAux = (result + x / result) >> 1;
            while (xAux < result) {
                result = xAux;
                xAux = (result + x / result) >> 1;
            }
            return result;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // https://github.com/Uniswap/v2-core/blob/585ee2ef824db671b71e351a91860a003c05431d/contracts/libraries/Math.sol
    // License: GPL-3.0; see https://github.com/Uniswap/v2-core/blob/585ee2ef824db671b71e351a91860a003c05431d/LICENSE
    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt_uni_v2(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // SPDX-License-Identifier: MIT; see https://github.com/PaulRBerg/prb-math/blob/28055f6cd9a2367f9ad7ab6c8e01c9ac8e9acc61/LICENSE.md
    // https://github.com/PaulRBerg/prb-math/blob/28055f6cd9a2367f9ad7ab6c8e01c9ac8e9acc61/src/Common.sol#L595
    /// @notice Calculates the square root of x using the Babylonian method.
    ///
    /// @dev See https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
    ///
    /// Notes:
    /// - If x is not a perfect square, the result is rounded down.
    /// - Credits to OpenZeppelin for the explanations in comments below.
    ///
    /// @param x The uint256 number for which to calculate the square root.
    /// @return result The result as a uint256.
    /// @custom:smtchecker abstract-function-nondet
    function sqrt_prb(uint256 x) internal pure returns (uint256 result) {
        if (x == 0) {
            return 0;
        }

        // For our first guess, we calculate the biggest power of 2 which is smaller than the square root of x.
        //
        // We know that the "msb" (most significant bit) of x is a power of 2 such that we have:
        //
        // $$
        // msb(x) <= x <= 2*msb(x)$
        // $$
        //
        // We write $msb(x)$ as $2^k$, and we get:
        //
        // $$
        // k = log_2(x)
        // $$
        //
        // Thus, we can write the initial inequality as:
        //
        // $$
        // 2^{log_2(x)} <= x <= 2*2^{log_2(x)+1} \\
        // sqrt(2^k) <= sqrt(x) < sqrt(2^{k+1}) \\
        // 2^{k/2} <= sqrt(x) < 2^{(k+1)/2} <= 2^{(k/2)+1}
        // $$
        //
        // Consequently, $2^{log_2(x) /2} is a good first approximation of sqrt(x) with at least one correct bit.
        uint256 xAux = uint256(x);
        result = 1;
        if (xAux >= 2 ** 128) {
            xAux >>= 128;
            result <<= 64;
        }
        if (xAux >= 2 ** 64) {
            xAux >>= 64;
            result <<= 32;
        }
        if (xAux >= 2 ** 32) {
            xAux >>= 32;
            result <<= 16;
        }
        if (xAux >= 2 ** 16) {
            xAux >>= 16;
            result <<= 8;
        }
        if (xAux >= 2 ** 8) {
            xAux >>= 8;
            result <<= 4;
        }
        if (xAux >= 2 ** 4) {
            xAux >>= 4;
            result <<= 2;
        }
        if (xAux >= 2 ** 2) {
            result <<= 1;
        }

        // At this point, `result` is an estimation with at least one bit of precision. We know the true value has at
        // most 128 bits, since it is the square root of a uint256. Newton's method converges quadratically (precision
        // doubles at every iteration). We thus need at most 7 iteration to turn our partial result with one bit of
        // precision into the expected uint128 result.
        unchecked {
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;

            // If x is not a perfect square, round the result toward zero.
            uint256 roundedResult = x / result;
            if (result >= roundedResult) {
                result = roundedResult;
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // SPDX-License-Identifier: BSD-4-Clause; see https://github.com/abdk-consulting/abdk-libraries-solidity/blob/9e69beb255e2f87d67b44047dae229ba42ee9a64/LICENSE.md
    // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/9e69beb255e2f87d67b44047dae229ba42ee9a64/ABDKMath64x64.sol#L727
    /**
     * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
     * number.
     *
     * @param x unsigned 256-bit integer number
     * @return unsigned 128-bit integer number
     */
    function sqrt_abdk(uint256 x) private pure returns (uint128) {
        unchecked {
            if (x == 0) return 0;
            else {
                uint256 xx = x;
                uint256 r = 1;
                if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
                if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
                if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
                if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
                if (xx >= 0x100) { xx >>= 8; r <<= 4; }
                if (xx >= 0x10) { xx >>= 4; r <<= 2; }
                if (xx >= 0x4) { r <<= 1; }
                r = (r + x / r) >> 1;
                r = (r + x / r) >> 1;
                r = (r + x / r) >> 1;
                r = (r + x / r) >> 1;
                r = (r + x / r) >> 1;
                r = (r + x / r) >> 1;
                r = (r + x / r) >> 1; // Seven iterations should be enough
                uint256 r1 = x / r;
                return uint128 (r < r1 ? r : r1);
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // SPDX-License-Identifier: MIT; see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6bf68a41d19f3d6e364d8c207cb7d1a9a8e542e1/LICENSE
    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6bf68a41d19f3d6e364d8c207cb7d1a9a8e542e1/contracts/utils/math/Math.sol#L220
    // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt_oz(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
