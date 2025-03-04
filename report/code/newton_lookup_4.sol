// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x <= 1) { return x; }

        // Here, e represents the "approximate" bit length
        uint256 e = 1;

        // Here, result is a copy of x to compute the bit length
        uint256 result = x;
        if (result >= (1 << 128)) { result >>= 128; e =  129; }
        if (result >= (1 <<  64)) { result >>=  64; e +=  64; }
        if (result >= (1 <<  32)) { result >>=  32; e +=  32; }
        if (result >= (1 <<  16)) { result >>=  16; e +=  16; }
        if (result >= (1 <<   8)) { result >>=   8; e +=   8; }
        if (result >= (1 <<   4)) { result >>=   4; e +=   4; }
        if (result >= (1 <<   2)) {                 e +=   2; }

        // overwrite e for scaling parameter
        e = (256 - e) >> 1;
        // m now satisfies 2**254 <= m < 2**256
        uint256 m = x << (2 * e);

        // need to initialize result
        result = uint256(uint8(lookup_table_4[(m >> 252)])) << 123;

        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result >>= e;

        if (result <= x/result) {
            return result;
        }
        return result-1;
    }
}

bytes constant lookup_table_4 =
"\x00\x00\x00\x00\x11\x13\x15\x16\x17\x19\x1a\x1b\x1c\x1d\x1e\x1f";
