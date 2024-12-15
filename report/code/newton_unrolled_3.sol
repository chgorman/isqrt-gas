// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x <= 1) { return x; }

        uint256 result = x;

        uint256 e = 1;

        if (x      >= (1 << 128)) { result >>= 128; e = 129; }
        if (result >= (1 <<  64)) { result >>=  64; e += 64; }
        if (result >= (1 <<  32)) { result >>=  32; e += 32; }
        if (result >= (1 <<  16)) { result >>=  16; e += 16; }
        if (result >= (1 <<   8)) { result >>=   8; e +=  8; }
        if (result >= (1 <<   4)) { result >>=   4; e +=  4; }
        if (result >= (1 <<   2)) {                 e +=  2; }
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
