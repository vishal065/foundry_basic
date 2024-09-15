// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

// 1- Deploy mocks when we are on local anvil chain
// 2- keep track of contract address accross different chains
// sepolia ETH/USD
// mainnet ETH/USD

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are on local chain/anvil we deploy mocks
    // otherwise, grab the existing address from the live network 
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE=2000e8;
    
    struct NetworkConfig {
        address priceFeed;  // ETH/USD price feed
    }

    constructor() {
     if (block.chainid ==11155111) {
        activeNetworkConfig =getSepoliaEthConfig();
     }if (block.chainid ==1) {
        activeNetworkConfig =getMainNetEthConfig();
     } else {
        activeNetworkConfig = getOrCreateAnvilEthConfig();
     }
    }


    function getSepoliaEthConfig()public pure returns(NetworkConfig memory){
        //price feed address
        //vrf address
        //gas price
        // for multiple return value we can turn this config into struct type
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
        // NetworkConfig memory sepoliaConfig = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306); //if single parameter we can also do like
        return sepoliaConfig;
    }

    function getMainNetEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory EthConfig = NetworkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        return EthConfig;
    }

    function getOrCreateAnvilEthConfig()public returns(NetworkConfig memory){

        if (activeNetworkConfig.priceFeed != address(0)) {
            //if we already below code i.e. mockPriceFeed contract then dont deploy again
            return activeNetworkConfig;
        }
        //price feed address
        //Deploy the mock 
        //return the mock
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed:address(mockPriceFeed)});
        return anvilConfig;

    }


}