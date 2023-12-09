// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import {Instance} from "src/level0.sol";

contract Level0Solve is Script{
    Instance public Level0 = Instance(0xc770F44bFDAe8eD857FaBeaFF5A702B87eAeC331);
    function run() external{
        string memory password = Level0.password();
        console.log("Password : ", password);
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Level0.authenticate(password);
        vm.stopBroadcast();
    }
}