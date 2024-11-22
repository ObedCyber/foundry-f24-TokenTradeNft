// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.18;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {FirstNFT} from "./FirstNFT.sol";
import {console} from "forge-std/console.sol";  


/** Custom Interface with mintNft function */
        interface ICustomNFT {
            function mintNFT(address _buyer) external;
        }
contract TokenTradeMarketplace is ReentrancyGuard, Ownable{

        

        /** Errors */
        error TokenTradeMarketplace_NftPriceNotAvailable();
        error TokenTradeMarketplace_TransferFailed();
        error TokenTradeMarketplace_InsufficientBalance(uint256 userBalance, uint256 price);
        error TokenTradeMarketplace_Invalidchoice();

        /** Interfaces */
        IERC20 public s_paymentToken;
        ICustomNFT public s_firstNftContract;
        ICustomNFT public s_secondNftContract;
   
        /** Type declarations */
        enum NftChoice {
            FirstNft,
            SecondNft
        }

        /** State variables */
        mapping(NftChoice => uint256) public s_nftChoicePrices; // tokenId to Price
        uint256 public s_priceUnitOfConversion = 1e18;

        constructor(address _paymentToken, address _firstNftContract, address _secondNftContract) Ownable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) {
            s_paymentToken = IERC20(_paymentToken);
            s_firstNftContract = ICustomNFT(_firstNftContract);
            s_secondNftContract = ICustomNFT(_secondNftContract);
        }

        /** Events */
        event PriceHasBeenSet(NftChoice indexed choice, uint256 indexed price);
        event NFTPurchased(address indexed buyer, NftChoice indexed choice, uint256 price);

        /** External functions */
        function setPrice(NftChoice choice, uint256 price) external onlyOwner {
            s_nftChoicePrices[choice] = price;
            emit PriceHasBeenSet(choice, price);
        }

        function purchaseNFT(NftChoice choice) external nonReentrant {
            uint256 price = s_nftChoicePrices[choice] ;
            if(price == 0)
            {
                revert TokenTradeMarketplace_NftPriceNotAvailable();
            }
             if(s_paymentToken.balanceOf(msg.sender) < uint256(price))
            {
                uint256 userbalance = s_paymentToken.balanceOf(msg.sender);
                revert TokenTradeMarketplace_InsufficientBalance(userbalance, price);
            } 

            bool success = s_paymentToken.transferFrom(msg.sender, address(this), price);
            if(!success) {
                revert TokenTradeMarketplace_TransferFailed(); 
            }
           
           // Call mint function based on the user's choice
        if (choice == NftChoice.FirstNft) {
            s_firstNftContract.mintNFT(msg.sender); // Assumes mint function exists in first NFT contract
            console.log("First NFT mint successfull");
        } 
         if (choice == NftChoice.SecondNft) {
            s_secondNftContract.mintNFT(msg.sender); // Assumes mint function exists in second NFT contract
        }

        emit NFTPurchased(msg.sender, choice, price);
       // console.log("Event emitted: Buyer %s, Choice %s, Price %s", msg.sender, choice, price);

        }


        

}