// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/DoubleEntryPoint.sol";

contract DoubleEntryPointSolve is Script {
    // GoodSamaritan public gs = GoodSamaritan(0x5887fc48Bd661cCD104998d3BB556b1879aC4cC2);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        vm.stopBroadcast();
    }
}

contract Attack{

}