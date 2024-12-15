// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.20;

// Import this file to use console.log
import "hardhat/console.sol";
import {SqrtStandard} from "./sqrt_standard_library.sol";

contract SqrtOpenZeppelinV2 {
    function sqrtcall(uint256 x) public view {
        uint256 g = gasleft();
        uint256 y = SqrtStandard.sqrt_oz_v2(x);
        console.log("%s, %s, %s", x, g - gasleft(), y);
    }
}