// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {TokenTradeMarketplace} from "../src/TokenTradeMarketplace.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {FirstNFT} from "../src/FirstNFT.sol";
import {SecondNFT} from "../src/SecondNFT.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployTokenTradeMarketplace is Script{

    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    uint256 public DEFAULT_ANVIL_KEY = vm.envUint("PRIVATE_KEY");
    

    function run() external returns(MyToken, FirstNFT, SecondNFT, TokenTradeMarketplace, address){
        string memory firstNftImageSvgCode = vm.readFile("./images/image1.svg");
        string memory secondNftImageSvgCode = vm.readFile("./images/image2.svg");
        address localAddress = vm.envAddress("LOCAL_ADDRESS");
        
        // this DEFAULT_ANVIL_KEY holds the initial supply of the mytoken
        vm.startBroadcast(DEFAULT_ANVIL_KEY);
        MyToken myToken = new MyToken(INITIAL_SUPPLY);
        FirstNFT firstNFT = new FirstNFT(
            svgToImageURI(firstNftImageSvgCode),
            localAddress
        );
        SecondNFT secondNFT = new SecondNFT(
            svgToImageURI(secondNftImageSvgCode),
            localAddress
        );

        TokenTradeMarketplace tokenTradeMarketplace = new TokenTradeMarketplace(address(myToken), address(firstNFT), address(secondNFT));

        firstNFT.transferOwnership(address(tokenTradeMarketplace));
        secondNFT.transferOwnership(address(tokenTradeMarketplace));

        console.log("MyToken deployed to:", address(myToken));
        console.log("firstNFT deployed to:", address(firstNFT));
        console.log("SecondNFT deployed to:", address(secondNFT));
        console.log("tokenTradeMarketplace deployed to:", address(tokenTradeMarketplace));
        
        vm.stopBroadcast();

        return (myToken, firstNFT, secondNFT, tokenTradeMarketplace, localAddress);
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg))) 
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}