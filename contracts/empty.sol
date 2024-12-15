// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.20;

// Import this file to use console.log
import "hardhat/console.sol";

contract Empty {
    function sqrtcall(uint256 x) public view {
        uint256 g = gasleft();
        console.log("%s, %s, %s", x, g - gasleft(), 0);
    }
}