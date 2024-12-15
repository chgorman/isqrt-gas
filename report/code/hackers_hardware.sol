// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        uint256 m = 2**254;
        uint256 y = 0;
        uint256 b = 0;

        while (m != 0) {
            b = y | m;
            y = y >> 1;
            if (x >= b) {
                x = x - b;
                y = y | m;
            }
            m = m >> 2;
        }

        return y;
    }
}
