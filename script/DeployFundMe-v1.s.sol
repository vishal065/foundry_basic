// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMeOld} from "../src/FundMe-v1.sol";

contract DeployFundMe is Script{
    function run() external {
        vm.startBroadcast();
         new FundMeOld();
        vm.stopBroadcast();
    }

}