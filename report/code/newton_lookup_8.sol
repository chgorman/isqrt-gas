// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    bytes memory lookup_table = lookup_table_8;
    assembly ("memory-safe") {
        // shift past the first 32 bytes
        // (as these store the array length)
        let data_ptr := add(lookup_table, 0x20)

        let e := clz(x)
        e := shr(1, e)
        let m := shl(shl(1, e), x)

        // the initial approximation
        result := shr(248, m) // get top 8 bits for index
        let word_ptr := add(data_ptr, result) // shift by index
        let word := mload(word_ptr) // grab 32-byte word
        result := byte(0, word) // get lookup value
        result := add(256, result) // add implicit high bit
        result := shl(119, result) // shift

        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(1, add(result, div(m, result)))
        result := shr(e, result)

        result := sub(result, gt(result, div(x, result)))
    }
}

bytes constant lookup_table_8 = "...";
