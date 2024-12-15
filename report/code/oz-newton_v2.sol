// SPDX-License-Identifier: MIT
function sqrt(uint256 a) internal pure returns (uint256) {
    unchecked {
        if (a <= 1) {
            return a;
        }

        uint256 aa = a;
        uint256 xn = 1;

        if (aa >= (1 << 128)) { aa >>= 128; xn <<= 64; }
        if (aa >= (1 <<  64)) { aa >>=  64; xn <<= 32; }
        if (aa >= (1 <<  32)) { aa >>=  32; xn <<= 16; }
        if (aa >= (1 <<  16)) { aa >>=  16; xn <<=  8; }
        if (aa >= (1 <<   8)) { aa >>=   8; xn <<=  4; }
        if (aa >= (1 <<   4)) { aa >>=   4; xn <<=  2; }
        if (aa >= (1 <<   2)) {             xn <<=  1; }

        xn = (3 * xn) >> 1;

        xn = (xn + a / xn) >> 1;
        xn = (xn + a / xn) >> 1;
        xn = (xn + a / xn) >> 1;
        xn = (xn + a / xn) >> 1;
        xn = (xn + a / xn) >> 1;
        xn = (xn + a / xn) >> 1;

        return xn - SafeCast.toUint(xn > a / xn);
    }
}