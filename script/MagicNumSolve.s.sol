// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {MagicNum} from "../src/MagicNum.sol";

contract MagicNumSolve is Script{

    function run() public{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Attack().exploit();
        vm.stopBroadcast();
    }

}

contract Attack{
    MagicNum public magicNum = MagicNum(0x396D3C79ecde0C91F14562d41ecf0F7685016b65);
    function exploit() public{
        /* Create a RUNTIME BYTECODE which returns 42 
        PUSH1 0x2a --> pushing 42 into stack
        PUSH1 0x00
        MSTORE --> Stores 0x2a at 0x00 location

        PUSH 0x20  --> pushing 32 into stack
        PUSH 0x00  
        RETURN  --> returns value at 0x00 to 0x20 in memory

        ---> Combining this will be runtime code : 602a60005260206000f3

        // Creating Creation code

        PUSH10 0x602a60005260206000f3
        PUSH 0x00
        MSTORE  --> Stores runtime bytecode at 0x00 in memory 


        PUSH 0x0a  --> push 10 into memory : Length of the run time code
        PUSH 0x16  --> push 22 into memory : Offset position
                // MSTORE stores 0x0000000000000000000000602a60005260206000f3 in memory
        RETURN

        ---> Creation Code : 69602a60005260206000f3600052600a6016f3
        */
       bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
       address _solver;
        // create(value, offset, size)
       assembly {
        _solver:= create(0, add(bytecode, 0x20), 0x13)
       }
       require(_solver != address(0));
       magicNum.setSolver(_solver);
    }
}