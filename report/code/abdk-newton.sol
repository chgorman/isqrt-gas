// SPDX-License-Identifier: BSD-4-Clause
function sqrt(uint256 x) private pure returns (uint128) {
    unchecked {
        if (x == 0) return 0;
        else {
            uint256 xx = x;
            uint256 r = 1;
            if (xx >= 0x100000000000000000000000000000000) {
                xx >>= 128; r <<= 64;
            }
            if (xx >= 0x10000000000000000) {
                xx >>= 64;  r <<= 32;
            }
            if (xx >= 0x100000000) {
                xx >>= 32;  r <<= 16;
            }
            if (xx >= 0x10000) {
                xx >>= 16;  r <<= 8;
            }
            if (xx >= 0x100) {
                xx >>= 8;   r <<= 4;
            }
            if (xx >= 0x10) {
                xx >>= 4;   r <<= 2;
            }
            if (xx >= 0x4) {
                            r <<= 1;
            }
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            // Seven iterations should be enough
            uint256 r1 = x / r;
            return uint128 (r < r1 ? r : r1);
        }
    }
}
