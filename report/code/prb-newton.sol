// SPDX-License-Identifier: MIT
function sqrt(uint256 x) internal pure returns (uint256 result) {
    if (x == 0) { return 0; }
    uint256 xAux = uint256(x);
    result = 1;
    if (xAux >= 2 ** 128) {
        xAux >>= 128;  result <<= 64;
    }
    if (xAux >= 2 ** 64) {
        xAux >>= 64;   result <<= 32;
    }
    if (xAux >= 2 ** 32) {
        xAux >>= 32;   result <<= 16;
    }
    if (xAux >= 2 ** 16) {
        xAux >>= 16;   result <<= 8;
    }
    if (xAux >= 2 ** 8) {
        xAux >>= 8;    result <<= 4;
    }
    if (xAux >= 2 ** 4) {
        xAux >>= 4;    result <<= 2;
    }
    if (xAux >= 2 ** 2) {
                       result <<= 1;
    }
    unchecked {
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        uint256 roundedResult = x / result;
        if (result >= roundedResult) {
            result = roundedResult;
        }
    }
}
