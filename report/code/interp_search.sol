// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x == 0) { return 0; }
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
        if (xAux >= (1 << 128)) { xAux >>= 128; left = 1 << 64; }
        if (xAux >= (1 <<  64)) { xAux >>=  64; left <<= 32; }
        if (xAux >= (1 <<  32)) { xAux >>=  32; left <<= 16; }
        if (xAux >= (1 <<  16)) { xAux >>=  16; left <<=  8; }
        if (xAux >= (1 <<   8)) { xAux >>=   8; left <<=  4; }
        if (xAux >= (1 <<   4)) { xAux >>=   4; left <<=  2; }
        if (xAux >= (1 <<   2)) {               left <<=  1; }

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
