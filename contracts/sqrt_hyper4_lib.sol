// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.20;

// Import this file to use console.log
import "hardhat/console.sol";

library SqrtHyper4Lib {
    ////////////////////////////////////////////////////////////////////////
    // Uses hyperbolic approximation to get 4 bits of precision
    function sqrt(uint256 x) internal pure returns (uint256) {
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
}