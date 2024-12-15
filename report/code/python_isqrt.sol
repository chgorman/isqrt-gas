// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x <= 1) { return x; }

        // Here, e represents the bit length
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
        if (result >= (1 <<   1)) {                 e +=   1; }

        // e is currently bit length; we overwrite it to scale x
        e = (256 - e) >> 1;

        // m now satisfies 2**254 <= m < 2**256
        uint256 m = x << (2 * e);

        // result now stores the result
        result = 1 + (m >> 254);
        result = (result <<  1) + (m >> 251) / result;
        result = (result <<  3) + (m >> 245) / result;
        result = (result <<  7) + (m >> 233) / result;
        result = (result << 15) + (m >> 209) / result;
        result = (result << 31) + (m >> 161) / result;
        result = (result << 63) + (m >>  65) / result;
        result >>= e;

        if (result <= x/result) {
            return result;
        }
        return result-1;
    }
}
