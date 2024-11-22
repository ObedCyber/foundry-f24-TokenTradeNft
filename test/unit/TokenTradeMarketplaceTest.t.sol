// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FirstNFT} from "../../src/FirstNFT.sol";
import {SecondNFT} from "../../src/SecondNFT.sol";
import {MyToken} from "../../src/MyToken.sol";
import {TokenTradeMarketplace} from "../../src/TokenTradeMarketplace.sol";
import {DeployTokenTradeMarketplace} from "../../script/DeployTokenTradeMarketplace.s.sol";
import {console} from "forge-std/console.sol";


contract TokenTradeMarketplaceTest is Test {


    FirstNFT public firstNFT;
    SecondNFT public secondNFT;
    TokenTradeMarketplace public marketPlace;
    MyToken public myToken;
    DeployTokenTradeMarketplace public deployer;
    address supplyHolder;

    address public USER = makeAddr("user");
    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant NFT_PRICE = 1 ether;

    address contractOwner = vm.envString(LOCAL_ADDRESS);
    error OwnableUnauthorizedAccount(address account);
    error TokenTradeMarketplace_InsufficientBalance(uint256 userBalance, uint256 price);
    error TokenTradeMarketplace_NftPriceNotAvailable();



    function setUp() public {
        deployer = new DeployTokenTradeMarketplace();
        (myToken, firstNFT, secondNFT, marketPlace, supplyHolder) = deployer.run();

        // Fund USER with MyToken
        // simulating the contract address holding the initial supply to transfer some tokens to User
        vm.startBroadcast(supplyHolder); 
        myToken.transfer(USER, STARTING_BALANCE);
        vm.stopBroadcast();

        // Set prices for NFTs
        vm.prank(contractOwner);
        marketPlace.setPrice(TokenTradeMarketplace.NftChoice.FirstNft, uint256(NFT_PRICE));
        vm.prank(contractOwner);
        marketPlace.setPrice(TokenTradeMarketplace.NftChoice.SecondNft, uint256(NFT_PRICE));
   
    }

    function testSetPriceEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit TokenTradeMarketplace.PriceHasBeenSet(TokenTradeMarketplace.NftChoice.FirstNft, NFT_PRICE);
        vm.prank(contractOwner);
        marketPlace.setPrice(TokenTradeMarketplace.NftChoice.FirstNft, NFT_PRICE );
    }

    function testMarketplaceCanMintNFT() public{
        vm.startPrank(address(marketPlace)); // Simulate NFTHolder minting the NFT
        firstNFT.mintNFT(USER);
        vm.stopPrank();

        assertEq(firstNFT.balanceOf(USER), 1);
    }

    function testOnlyOwnerCanSetPrice() public {
        vm.prank(USER);
        vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, USER)); // Expect the specific custom error     
        marketPlace.setPrice(TokenTradeMarketplace.NftChoice.FirstNft, 1);
    }
    
    function testPurchaseFirstNFT() public {
        vm.startPrank(USER);

        myToken.approve(address(marketPlace), 1 ether);

        vm.expectEmit(true, true, true, true);
        emit TokenTradeMarketplace.NFTPurchased(USER, TokenTradeMarketplace.NftChoice.FirstNft, NFT_PRICE);


        marketPlace.purchaseNFT(TokenTradeMarketplace.NftChoice.FirstNft);

        assertEq(firstNFT.balanceOf(USER), 1);
        assertEq(myToken.balanceOf(address(marketPlace)), NFT_PRICE);
        assertEq(myToken.balanceOf(USER), STARTING_BALANCE - NFT_PRICE);

        vm.stopPrank();
    }

    function testPurchaseSecondNFT() public {
        vm.startPrank(USER);

        myToken.approve(address(marketPlace), NFT_PRICE);

        vm.expectEmit(true, true, true, true);
        emit TokenTradeMarketplace.NFTPurchased(USER, TokenTradeMarketplace.NftChoice.SecondNft, NFT_PRICE);

        marketPlace.purchaseNFT(TokenTradeMarketplace.NftChoice.SecondNft);

        assertEq(secondNFT.balanceOf(USER), 1);
        assertEq(myToken.balanceOf(address(marketPlace)), NFT_PRICE);
        assertEq(myToken.balanceOf(USER), STARTING_BALANCE - NFT_PRICE);

        vm.stopPrank();
    }

    function testCannotPurchaseWithoutEnoughBalance() public {
        vm.startPrank(USER);

        uint256 lowBalance = NFT_PRICE / 2; //0.5 ether
        myToken.transfer(address(2), STARTING_BALANCE - lowBalance); //transfer 100 - 0.5 ether = 99.5 ether 
        assertEq(myToken.balanceOf(USER), lowBalance);

        vm.expectRevert(abi.encodeWithSelector(TokenTradeMarketplace_InsufficientBalance.selector, lowBalance, NFT_PRICE));
        marketPlace.purchaseNFT(TokenTradeMarketplace.NftChoice.FirstNft);

        vm.stopPrank();
    }

    function testCannotPurchaseWithoutPriceSet() public {
        vm.prank(contractOwner);
        marketPlace.setPrice(TokenTradeMarketplace.NftChoice.FirstNft, 0);

        vm.startPrank(USER);

        vm.expectRevert(abi.encodeWithSelector(TokenTradeMarketplace_NftPriceNotAvailable.selector));
        marketPlace.purchaseNFT(TokenTradeMarketplace.NftChoice.FirstNft);

        vm.stopPrank();
    }

}