// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x <= 1) { return x; }

        uint256 xAux = x;
        uint256 left = 1;
        if (xAux >= (1 << 128)) { xAux >>= 128; left = 1 << 64; }
        if (xAux >= (1 << 64))  { xAux >>=  64; left <<= 32;    }
        if (xAux >= (1 << 32))  { xAux >>=  32; left <<= 16;    }
        if (xAux >= (1 << 16))  { xAux >>=  16; left <<=  8;    }
        if (xAux >= (1 << 8))   { xAux >>=   8; left <<=  4;    }
        if (xAux >= (1 << 4))   { xAux >>=   4; left <<=  2;    }
        if (xAux >= (1 << 2))   {               left <<=  1;    }

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
