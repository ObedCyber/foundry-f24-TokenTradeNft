// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";
import {console} from "forge-std/console.sol";

contract DeployMyToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    uint256 public DEFAULT_ANVIL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;


    function run() external returns (MyToken, address) {
        address localAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startBroadcast(DEFAULT_ANVIL_KEY);
        MyToken myToken = new MyToken(INITIAL_SUPPLY);
        // 0x5FbDB2315678afecb367f032d93F642f64180aa3
        console.log("MyToken deployed to:", address(myToken));
        vm.stopBroadcast();
        return (myToken, localAddress);
    }
}