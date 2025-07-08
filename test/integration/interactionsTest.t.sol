// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,withdrawFundme} from "../../script/interactions.s.sol";



contract FundmeTest is Test {

    uint256 num = 1;
    FundMe fundme;
    address public user=makeAddr("user");
    uint256 constant send_value=6e18;
    uint256 constant starting_balance= 100e18;
    uint256 constant Gas_Price=1;

    function setUp() external{
        DeployFundMe deployfundme= new DeployFundMe();
        fundme=deployfundme.run();
        vm.deal(user,send_value);


    }

    function testUserCanFundInteractions() public{
        FundFundMe fundFundMe=new FundFundMe();
        vm.deal(address(fundFundMe), 1 ether);

        fundFundMe.fundFundMe(address(fundme));

        withdrawFundme withdrawfundme= new withdrawFundme();
        withdrawfundme.withdrawfundme(address(fundme));

        assert(address(fundme).balance==0);

    }
}