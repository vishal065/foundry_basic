// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMeOld} from "../src/FundMe-v1.sol";

contract FundMeTest is Test {
    // uint256 number =2;
    FundMeOld fundme;
    function setUp() external {
        
        fundme = new FundMeOld();
    }

    function testMinimumDollerIsFIve() public view{
        assertEq(fundme.MINIMUM_USD(), 5e18);
        // assertEq(number,2);

    }
    function testOwnerIsSender() public view{
        //us deploy -> fundmeTest -> fundme
        //wrong explaintaion we didnt deploy fundme - fundmeTest deploy fundme
        // assertEq(fundme.i_owner(), msg.sender);  
        assertEq(fundme.i_owner(),address(this));
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundme.getVersion();
        assertEq(version,4);
    }

}
