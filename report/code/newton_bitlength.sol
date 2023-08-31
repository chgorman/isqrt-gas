// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x <= 1) { return x; }
        if (x >= ((1 << 128) - 1)**2) { return (1 << 128) - 1; }

        // Here, e represents the bit length;
        // its value is at most 256, so it could fit in a uint16.
        uint256 e = 1;
        // Here, result is a copy of x to compute the bit length
        uint256 result = x;
        if (result >= (1 << 128)) { result >>= 128; e =  129; }
        if (result >= (1 <<  64)) { result >>=  64; e +=  64; }
        if (result >= (1 <<  32)) { result >>=  32; e +=  32; }
        if (result >= (1 <<  16)) { result >>=  16; e +=  16; }
        if (result >= (1 <<   8)) { result >>=   8; e +=   8; }
        if (result >= (1 <<   4)) { result >>=   4; e +=   4; }
        if (result >= (1 <<   2)) { result >>=   2; e +=   2; }

        if (result >= (1 <<   1)) {
            result = (27 << (e/2)) >> 4;
        } else {
            result = (39 << (e/2)) >> 5;
        }

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
