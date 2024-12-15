// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.20;

// Import this file to use console.log
import "hardhat/console.sol";

import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

library SqrtStandard {
    ////////////////////////////////////////////////////////////////////////
    // initialization is largest power-of-2 <= isqrt(x)
    function sqrt_newton_unrolled_1(uint256 x) internal pure returns (uint256) {
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
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result <= x/result) {
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
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result <= x/result) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Original idea but updated initialization method
    // initialize with better approximation
    function sqrt_newton_unrolled_3(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }
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

            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result <= x/result) {
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

            result = (result + x / result) >> 1;
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
            result = (3 * result) >> 1;

            result = (result + x / result) >> 1;
            xAux = (result + x / result) >> 1;
            while (xAux < result) {
                result = xAux;
                xAux = (result + x / result) >> 1;
            }
            return result;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Use full info from bit length
    function sqrt_newton_bitlength(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }

            // Here, result is a copy of x to compute the bit length
            uint256 result = x;
            // Here, e represents the (approximate) bit length;
            // its value is at most 256, so it could fit in a uint16.
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
            // Suppose
            //
            //      2^(2k-2) <= x < 2^(2k)
            //
            // At this point, e == 2k-1.
            // This means that
            //
            //      1 << (e/2) ==  2**(k-1)
            if (result >= (1 << 1)) {
                // normally would include
                //
                //      e += 1
                //
                // so we should really have e == 2k, so bitlength is even.
                result = (27 << (e/2)) >> 4;
            } else {
                // We actually have
                //
                //      e == 2k-1
                //
                // so bitlength is odd.
                result = (39 << (e/2)) >> 5;
            }

            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            if (result <= x/result) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Use linear approximation
    function sqrt_newton_linear(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }

            // Here, result is a copy of x to compute the bit length
            uint256 result = x;
            // Here, e represents the bit length;
            // its value is at most 256, so it could fit in a uint16.
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
            // e is currently bit length; we overwrite it to scale x
            e = (256 - e) >> 1;
            // m now satisfies 2**254 <= m < 2**256
            uint256 m = x << (2 * e);
            // result now stores the result

            // need to initialize result
            result = m >> 252;
            result = (14 + result) << 123;

            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result >>= e;

            if (result <= x/result) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // New design
    // Uses hyperbolic approximation to get 4 bits of precision
    function sqrt_newton_hyper_4(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }

            // Here, result is a copy of x to compute the bit length
            uint256 result = x;
            // Here, e represents the bit length;
            // its value is at most 256, so it could fit in a uint16.
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
            // e is currently bit length; we overwrite it to scale x
            e = (256 - e) >> 1;
            // m now satisfies 2**254 <= m < 2**256
            uint256 m = x << (2 * e);
            // result now stores the result

            // need to initialize result
            result = m >> 252;
            result = (512/(31 - result)) << 123;

            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result >>= e;

            if (result <= x/result) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // New design
    // Uses table lookups for 4 bits of precision
    // First 4 bytes are zero bytes
    bytes constant lookup_table_4 = "\x00\x00\x00\x00\x11\x13\x15\x16\x17\x19\x1a\x1b\x1c\x1d\x1e\x1f";

    function sqrt_newton_lookup_4(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }

            // Here, result is a copy of x to compute the bit length
            uint256 result = x;
            // Here, e represents the bit length;
            // its value is at most 256, so it could fit in a uint16.
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
            // e is currently bit length; we overwrite it to scale x
            e = (256 - e) >> 1;
            // m now satisfies 2**254 <= m < 2**256
            uint256 m = x << (2 * e);
            // result now stores the result

            // need to initialize result
            result = uint256(uint8(lookup_table_4[(m >> 252)])) << 123;

            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result >>= e;

            if (result <= x/result) {
                return result;
            }
            return result-1;
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // New design
    // Uses table lookups for 8 bits of precision
    // First 64 bytes are zero bytes
    bytes constant lookup_table_8 = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x03\x05\x07\x09\x0b\x0d\x0f\x11\x13\x15\x16\x18\x1a\x1c\x1e\x1f\x21\x23\x25\x27\x28\x2a\x2c\x2d\x2f\x31\x32\x34\x36\x37\x39\x3b\x3c\x3e\x3f\x41\x43\x44\x46\x47\x49\x4b\x4c\x4e\x4f\x51\x52\x54\x55\x57\x58\x5a\x5b\x5d\x5e\x5f\x61\x62\x64\x65\x67\x68\x6a\x6b\x6c\x6e\x6f\x71\x72\x73\x75\x76\x77\x79\x7a\x7b\x7d\x7e\x7f\x81\x82\x83\x85\x86\x87\x89\x8a\x8b\x8d\x8e\x8f\x90\x92\x93\x94\x96\x97\x98\x99\x9b\x9c\x9d\x9e\x9f\xa1\xa2\xa3\xa4\xa6\xa7\xa8\xa9\xaa\xac\xad\xae\xaf\xb0\xb2\xb3\xb4\xb5\xb6\xb7\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff";

    function sqrt_newton_lookup_8(uint256 x) internal pure returns (uint256) {
        unchecked {
            if (x <= 1) {
                return x;
            }

            // Here, result is a copy of x to compute the bit length
            uint256 result = x;
            // Here, e represents the bit length;
            // its value is at most 256, so it could fit in a uint16.
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
            // e is currently bit length; we overwrite it to scale x
            e = (256 - e) >> 1;
            // m now satisfies 2**254 <= m < 2**256
            uint256 m = x << (2 * e);
            // result now stores the result

            // need to initialize result
            result = 2**127 + (uint256(uint8(lookup_table_8[(m >> 248)])) << 119);

            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result = (result + m / result) >> 1;
            result >>= e;

            if (result <= x/result) {
                return result;
            }
            return result-1;
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
    function sqrt_abdk(uint256 x) internal pure returns (uint128) {
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

    ////////////////////////////////////////////////////////////////////////
    // SPDX-License-Identifier: MIT; see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/140d66fad8b3d8bf1fe793fc73d5e0a9f55f16e3/LICENSE
    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/140d66fad8b3d8bf1fe793fc73d5e0a9f55f16e3/contracts/utils/math/Math.sol#L391
    // OpenZeppelin Contracts (last updated v5.1.0) (utils/math/Math.sol)
    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * This method is based on Newton's method for computing square roots; the algorithm is restricted to only
     * using integer operations.
     */
    function sqrt_oz_v2(uint256 a) internal pure returns (uint256) {
        unchecked {
            // Take care of easy edge cases when a == 0 or a == 1
            if (a <= 1) {
                return a;
            }

            // In this function, we use Newton's method to get a root of `f(x) := x² - a`. It involves building a
            // sequence x_n that converges toward sqrt(a). For each iteration x_n, we also define the error between
            // the current value as `ε_n = | x_n - sqrt(a) |`.
            //
            // For our first estimation, we consider `e` the smallest power of 2 which is bigger than the square root
            // of the target. (i.e. `2**(e-1) ≤ sqrt(a) < 2**e`). We know that `e ≤ 128` because `(2¹²⁸)² = 2²⁵⁶` is
            // bigger than any uint256.
            //
            // By noticing that
            // `2**(e-1) ≤ sqrt(a) < 2**e → (2**(e-1))² ≤ a < (2**e)² → 2**(2*e-2) ≤ a < 2**(2*e)`
            // we can deduce that `e - 1` is `log2(a) / 2`. We can thus compute `x_n = 2**(e-1)` using a method similar
            // to the msb function.
            uint256 aa = a;
            uint256 xn = 1;

            if (aa >= (1 << 128)) {
                aa >>= 128;
                xn <<= 64;
            }
            if (aa >= (1 << 64)) {
                aa >>= 64;
                xn <<= 32;
            }
            if (aa >= (1 << 32)) {
                aa >>= 32;
                xn <<= 16;
            }
            if (aa >= (1 << 16)) {
                aa >>= 16;
                xn <<= 8;
            }
            if (aa >= (1 << 8)) {
                aa >>= 8;
                xn <<= 4;
            }
            if (aa >= (1 << 4)) {
                aa >>= 4;
                xn <<= 2;
            }
            if (aa >= (1 << 2)) {
                xn <<= 1;
            }

            // We now have x_n such that `x_n = 2**(e-1) ≤ sqrt(a) < 2**e = 2 * x_n`. This implies ε_n ≤ 2**(e-1).
            //
            // We can refine our estimation by noticing that the the middle of that interval minimizes the error.
            // If we move x_n to equal 2**(e-1) + 2**(e-2), then we reduce the error to ε_n ≤ 2**(e-2).
            // This is going to be our x_0 (and ε_0)
            xn = (3 * xn) >> 1; // ε_0 := | x_0 - sqrt(a) | ≤ 2**(e-2)

            // From here, Newton's method give us:
            // x_{n+1} = (x_n + a / x_n) / 2
            //
            // One should note that:
            // x_{n+1}² - a = ((x_n + a / x_n) / 2)² - a
            //              = ((x_n² + a) / (2 * x_n))² - a
            //              = (x_n⁴ + 2 * a * x_n² + a²) / (4 * x_n²) - a
            //              = (x_n⁴ + 2 * a * x_n² + a² - 4 * a * x_n²) / (4 * x_n²)
            //              = (x_n⁴ - 2 * a * x_n² + a²) / (4 * x_n²)
            //              = (x_n² - a)² / (2 * x_n)²
            //              = ((x_n² - a) / (2 * x_n))²
            //              ≥ 0
            // Which proves that for all n ≥ 1, sqrt(a) ≤ x_n
            //
            // This gives us the proof of quadratic convergence of the sequence:
            // ε_{n+1} = | x_{n+1} - sqrt(a) |
            //         = | (x_n + a / x_n) / 2 - sqrt(a) |
            //         = | (x_n² + a - 2*x_n*sqrt(a)) / (2 * x_n) |
            //         = | (x_n - sqrt(a))² / (2 * x_n) |
            //         = | ε_n² / (2 * x_n) |
            //         = ε_n² / | (2 * x_n) |
            //
            // For the first iteration, we have a special case where x_0 is known:
            // ε_1 = ε_0² / | (2 * x_0) |
            //     ≤ (2**(e-2))² / (2 * (2**(e-1) + 2**(e-2)))
            //     ≤ 2**(2*e-4) / (3 * 2**(e-1))
            //     ≤ 2**(e-3) / 3
            //     ≤ 2**(e-3-log2(3))
            //     ≤ 2**(e-4.5)
            //
            // For the following iterations, we use the fact that, 2**(e-1) ≤ sqrt(a) ≤ x_n:
            // ε_{n+1} = ε_n² / | (2 * x_n) |
            //         ≤ (2**(e-k))² / (2 * 2**(e-1))
            //         ≤ 2**(2*e-2*k) / 2**e
            //         ≤ 2**(e-2*k)
            xn = (xn + a / xn) >> 1; // ε_1 := | x_1 - sqrt(a) | ≤ 2**(e-4.5)  -- special case, see above
            xn = (xn + a / xn) >> 1; // ε_2 := | x_2 - sqrt(a) | ≤ 2**(e-9)    -- general case with k = 4.5
            xn = (xn + a / xn) >> 1; // ε_3 := | x_3 - sqrt(a) | ≤ 2**(e-18)   -- general case with k = 9
            xn = (xn + a / xn) >> 1; // ε_4 := | x_4 - sqrt(a) | ≤ 2**(e-36)   -- general case with k = 18
            xn = (xn + a / xn) >> 1; // ε_5 := | x_5 - sqrt(a) | ≤ 2**(e-72)   -- general case with k = 36
            xn = (xn + a / xn) >> 1; // ε_6 := | x_6 - sqrt(a) | ≤ 2**(e-144)  -- general case with k = 72

            // Because e ≤ 128 (as discussed during the first estimation phase), we know have reached a precision
            // ε_6 ≤ 2**(e-144) < 1. Given we're operating on integers, then we can ensure that xn is now either
            // sqrt(a) or sqrt(a) + 1.
            return xn - SafeCast.toUint(xn > a / xn);
        }
    }
}