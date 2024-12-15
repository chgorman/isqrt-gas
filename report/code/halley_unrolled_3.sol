// SPDX-License-Identifier: 0BSD
// NOTE: return logic has not been verified.
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        if (x <= 1) { return x; }

        uint256 xAux = x;

        uint256 result = 1;

        if (xAux >= (1 << 128)) { xAux >>= 128; result = 1 << 64; }
        if (xAux >= (1 <<  64)) { xAux >>=  64; result <<= 32; }
        if (xAux >= (1 <<  32)) { xAux >>=  32; result <<= 16; }
        if (xAux >= (1 <<  16)) { xAux >>=  16; result <<=  8; }
        if (xAux >= (1 <<   8)) { xAux >>=   8; result <<=  4; }
        if (xAux >= (1 <<   4)) { xAux >>=   4; result <<=  2; }
        if (xAux >= (1 <<   2)) {               result <<=  1; }
        result = (3*result) >> 1;

        result = (result * (result**2 + 3*x))/(3*result**2 + x);
        result = (result * (result**2 + 3*x))/(3*result**2 + x);
        result = (result * (result**2 + 3*x))/(3*result**2 + x);
        result = (result * (result**2 + 3*x))/(3*result**2 + x);

        // TODO: determine correct return logic
        if (result <= x/result) {
            return result;
        }
        return result-1;
    }
}
