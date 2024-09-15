// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe-v2.sol";
import {DeployFundMe} from "../../script/DeployFundMe-v2.s.sol";

contract FundMeTest is Test {
    // uint256 number =2;
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; //100000000000000000
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollerIsFIve() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
        // assertEq(number,2);
    }

    function testOwnerIsSender() public view {
        //deployFundMe -> fundmeTest
        assertEq(fundme.getOwner(), msg.sender);
    }

    /*
    type of test
    1 - unit
    2 - integration
    3 - forked
    4 - staging
    */

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundFailNotEnougthETH() public {
        vm.expectRevert(); //hey the next line should revert
        fundme.fund(); //send 0 eth
    }

    function testFundUpdateFundedDataStructure() public {
        vm.prank(USER); // the next TX will be send by USER
        fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // vm.prank(USER);
        // fundme.fund{value:SEND_VALUE}(); //commented this code because we hv added modifier
        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        //arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;
        //act or action
        //by default if we can using anvil rpc means locally then gas is 0
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = gasStart - gasEnd * tx.gasprice;
        console.log("gas start", gasStart);
        console.log("gas end", gasEnd);
        console.log("gas useed", gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;
        // assertEq(endingFundMeBalance , endingOwnerBalance);  //wrong give error
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithDrawFromMultipleFunders() public funded {
        //arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; //we starting from 1 because sometimes 0 index reverse and doesnt let you do stuff with that
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal  new address
            //cannot generate address from number to do so we can so something like that
            // uint256 abc = uint256(uint160(msg.sender))

            //forge have another cheat code to do so
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }
        uint256 startOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        //Act
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        //Assert
        assert(address(fundme).balance == 0);
        assert(
            startingFundMeBalance + startOwnerBalance ==
                fundme.getOwner().balance
        );
    }

    function testWithDrawFromMultipleFundersCheaper() public funded {
        //arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }
        uint256 startOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        //Act
        vm.startPrank(fundme.getOwner());
        fundme.cheaperWithDraw();
        vm.stopPrank();

        //Assert
        assert(address(fundme).balance == 0);
        assert(
            startingFundMeBalance + startOwnerBalance ==
                fundme.getOwner().balance
        );
    }
}
