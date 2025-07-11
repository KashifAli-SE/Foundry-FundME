// 1. Deploy Mocks when on a local anvil chain
// 2. Keep track of contract address accross different chains
// such as Sepolia ETH/USD, MAINNET ETH/USD Price 

// SPDX-License-Provider: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol" ;

contract HelperConfig is Script{
    // if we are on a local anvil chain, we deploy mocks
    // otherwise, grab the existing address from the live network

    uint8 public constant decimals=8;
    int256 public constant initial_price=2000e8;

    NetworkConfig public activeNetworkConfig;

    struct  NetworkConfig {
        address pricefeed;
    }

    function getConfig() public returns(address ){
        return activeNetworkConfig.pricefeed;
    }

    constructor(){
        if(block.chainid==11155111){
            activeNetworkConfig=getSepoliaEthConfig();
        } 
        else if(block.chainid==1) {
            activeNetworkConfig=getMainnetEthConfig();
        }else if (block.chainid == 31337) {

            activeNetworkConfig=getorCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory SepoliaConfig=NetworkConfig({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return SepoliaConfig;

    }
    function getMainnetEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory MainnetEthConfig=NetworkConfig({pricefeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return MainnetEthConfig;

    }

    function getorCreateAnvilEthConfig() public  returns (NetworkConfig memory){
        // PriceFeed Address

        // 1. Deploy the mocks
        // 2. Return the Mock Address
        if(activeNetworkConfig.pricefeed != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed=new MockV3Aggregator(
        decimals,initial_price
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig=NetworkConfig({
        pricefeed: address(mockPriceFeed)
        });
        return anvilConfig;
   
        }     

}