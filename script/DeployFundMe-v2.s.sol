// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe-v2.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external returns(FundMe) {
        // before start broadcast -> not a real tx
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        // (ethUsdPriceFeed, , , ,)  = helperConfig.activeNetworkConfig(); if multiple values ! well where that would be define? inside struct NetworkConfig in HelperConfig file

        // After start broadcast -> real tx
        vm.startBroadcast();
        FundMe fundme =  new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundme;
    }

}