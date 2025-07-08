// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundmeTest is Test {
    uint256 num = 1;
    FundMe fundme;
    address public user=makeAddr("user");
    uint256 constant send_value=6e18;
    uint256 constant starting_balance= 100e18;
    uint256 constant Gas_Price=1;
    
    function setUp() external {
        // fundme=new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployfundme=new DeployFundMe();
        fundme=deployfundme.run();
        vm.deal(user,starting_balance);
    }

    function testMiniDollarIsFive() public view{
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }
    function testOwnerisMsgSender() public view{
        console.log(fundme.getOwner());
        console.log(msg.sender);
        assertEq(fundme.getOwner(),msg.sender);
    }
    // function testPriceFeedVersionisAccurate() public view {
    //     uint256 version = fundme.getVersion();
    //     // console.log("version is ==== ", version);
    //     assertEq(version,4);
    // }
    modifier funded(){  //solidity best practice for testing to avoid repeatition
        vm.prank(user);
        fundme.fund{value:send_value}();
        _;
    }

    function testFundmeFailsWithoutEnoughEth() public{
        vm.expectRevert(); // expects that next line will revert. 
        fundme.fund();
    }

    function testFundUpdatesFundedDataStructure() public funded{
        uint256 amountFunded=fundme.getAddresstoAmountFunded(user);
        assertEq(amountFunded, send_value);
    }

    function testAddFunderToArrayOfFunders() public funded{
        
        address funder=fundme.getFunder(0);
        assertEq(funder,user);
    }
    function testOwnlyOwnerCanWithdraw() public funded{

        vm.expectRevert();
        vm.prank(user); //vm.expectRevert will not expect vm.prank to revert because its a vm command/cheatcode
        fundme.withdraw(); //vm.expectRevert will expect fundme.withdraw to revert, because user is not the owner. 
    }

    function testWithDrawWithASingleFunder() public funded{
        uint256 startingOwnerBalance=fundme.getOwner().balance;
        uint256 startingFundmeBalance=address(fundme).balance;

        uint256 gasStart=gasleft();
        vm.txGasPrice(Gas_Price);
        vm.prank(fundme.getOwner());
        fundme.cheaperWithdraw();

        uint256 gasEnd=gasleft();
        uint256 gasUsed=(gasStart-gasEnd)* tx.gasprice;

        console.log(gasUsed);

        uint256 endingOwnerBalance=fundme.getOwner().balance;
        uint256 endingFundmeBalance=address(fundme).balance;

        assertEq(endingFundmeBalance,0);
        assertEq(startingOwnerBalance+startingFundmeBalance,endingOwnerBalance);
    }

    function testWithDrawWithMultipleFunders() public funded {
        uint160 numberofFunders=10;
        uint160 startingFunderIndex=1;
        for(uint160 i=startingFunderIndex; i<numberofFunders; i++){

            hoax(address(i),send_value);
            fundme.fund{value: send_value}();

        }
        uint256 startingOwnerBalance=fundme.getOwner().balance;
        uint256 startingFundmeBalance=address(fundme).balance;

        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();
        
        assertEq(address(fundme).balance,0);
        assertEq(startingFundmeBalance+startingOwnerBalance , fundme.getOwner().balance);
    }

} 
