// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FirstNFT} from "../../src/FirstNFT.sol";
import {SecondNFT} from "../../src/SecondNFT.sol";
import {MyToken} from "../../src/MyToken.sol";
import {DeployMyNFT} from "../../script/DeployMyNFT.s.sol";
import {console} from "forge-std/console.sol";
import {Base64} from "../../lib/openzeppelin-contracts/contracts/utils/Base64.sol";


contract MyNFTtest is Test {

    FirstNFT public firstNFT;
    SecondNFT public secondNFT;
    DeployMyNFT public deployer;

    address NFTHolder;
    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");
    address public USER3 = makeAddr("user3");


    string public FIRST_IMAGE_URI;
    string public SECOND_IMAGE_URI;
    string  FIRST_IMAGE_SVG = vm.readFile("./images/image1.svg");
    string  SECOND_IMAGE_SVG = vm.readFile("./images/image2.svg");
    
    
    function setUp() public {
        deployer = new DeployMyNFT();
        (firstNFT, secondNFT, NFTHolder) = deployer.run();  
        FIRST_IMAGE_URI = deployer.svgToImageURI(FIRST_IMAGE_SVG);
/*         console.log("first IMAGE URI: ", FIRST_IMAGE_URI);
 */        SECOND_IMAGE_URI = deployer.svgToImageURI(SECOND_IMAGE_SVG);
/*         console.log("second IMAGE URI: ", SECOND_IMAGE_URI);
 */    }
    
    /** 
     * @dev This test simulates the NFTHolder minting the first NFT for the user. It checks that the user receives the NFT and verifies the correct token URI is returned.
     */
    function testMintFirstNFT() public {
        vm.startPrank(NFTHolder); // Simulate NFTHolder minting the NFT
        firstNFT.mintNFT(USER);
        vm.stopPrank();

        assertEq(firstNFT.balanceOf(USER), 1);
        assertEq(firstNFT.tokenURI(0), constructTokenURI(FIRST_IMAGE_URI));
    }

    /** 
     * @dev Similar to the first test but mints the second NFT. It verifies the user's balance and the corresponding token URI.
     */
    function testMintSecondNFT() public {
        vm.startPrank(NFTHolder);
        secondNFT.mintNFT(USER);
        vm.stopPrank();

        assertEq(secondNFT.balanceOf(USER), 1); // User should have one NFT now
        assertEq(secondNFT.tokenURI(0), constructTokenURI(SECOND_IMAGE_URI));
    }

    /**
     * @dev It tests minting both NFTs sequentially for the same user and checks that the user’s balance reflects two NFTs.
     */
     function testMintingMultipleNFTs() public {
        vm.startPrank(NFTHolder);
        secondNFT.mintNFT(USER);
        secondNFT.mintNFT(USER2);
        secondNFT.mintNFT(USER2);
        secondNFT.mintNFT(USER);

        vm.stopPrank();
        assertEq(secondNFT.balanceOf(USER), 2);
        assertEq(secondNFT.balanceOf(USER2), 2);
    }

    function constructTokenURI(string memory imageUri) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "FirstNFT',
                            '", "description": "A unique NFT asset.", "image": "',
                            imageUri,'"}'
                        )
                    )
                )
            )
        );
    }

}
