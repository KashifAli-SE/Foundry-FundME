// SPDX-License-Identifier: MIT
// SPDX-License-Provider: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external  returns (FundMe) {

        // before broadcast-> this is not a real transection
        HelperConfig helperconfig=new HelperConfig();
        address ethusdpricefeed=helperconfig.getConfig();

        // after broadcast real transection starts
        vm.startBroadcast();
        FundMe fundme=new FundMe(ethusdpricefeed);
        vm.stopBroadcast();
        return fundme;
    }
}