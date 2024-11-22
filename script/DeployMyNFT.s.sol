// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FirstNFT} from "../src/FirstNFT.sol";
import {SecondNFT} from "../src/SecondNFT.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployMyNFT is Script{
    function run() external returns(FirstNFT, SecondNFT, address)
    {
        string memory firstNftImageSvgCode = vm.readFile("./images/image1.svg");
        string memory secondNftImageSvgCode = vm.readFile("./images/image2.svg");
        address localAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startBroadcast();
        FirstNFT firstNFT = new FirstNFT(
            svgToImageURI(firstNftImageSvgCode),
            localAddress
        );
        SecondNFT secondNFT = new SecondNFT(
            svgToImageURI(secondNftImageSvgCode),
            localAddress
        );
        // 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
        console.log("FirstNFT deployed to:", address(firstNFT));
        console.log("SecondNFT deployed to:", address(secondNFT));
        vm.stopBroadcast();
        
        return (firstNFT, secondNFT, localAddress);
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg))) 
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}












