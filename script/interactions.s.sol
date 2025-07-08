// SPDX-License-Identifier: MIT

// FUND
// Withdraw
pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract FundFundMe is Script{

    uint256 send_value=0.1 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
       
        FundMe(payable(mostRecentlyDeployed)).fund{value: send_value}();
        vm.deal(0x90193C961A926261B756D1E5bb255e67ff9498A1,100e18);
    
        console.log("funded fundme with %s",send_value);
    }

    function run() external{
  
    address mostRecentlydeployed=DevOpsTools.get_most_recent_deployment(
        "fundme",
        block.chainid
    );

    vm.startBroadcast();
    fundFundMe(mostRecentlydeployed);
    vm.stopBroadcast();
    }

}

contract withdrawFundme is Script{

    function withdrawfundme(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external{
  
    address mostRecentlydeployed=DevOpsTools.get_most_recent_deployment(
        "fundme",
        block.chainid
    );
    
    vm.startBroadcast();
    withdrawfundme(mostRecentlydeployed);
    vm.stopBroadcast();
    }
}