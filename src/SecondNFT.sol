// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {console} from "forge-std/console.sol";

contract SecondNFT is ERC721, Ownable  {

    uint256 private s_tokencounter;
    string private s_secondImageUri;

 constructor(
        string memory secondImageURI,
        address initialOwner
    ) ERC721("SecondNFT","SNFT") Ownable(initialOwner){
        s_secondImageUri = secondImageURI;
        s_tokencounter = 0;
    }

    // TokenTradeMarketplace mints NFT directly to _buyer
    function mintNFT(address _buyer) external onlyOwner {
        _safeMint(_buyer, s_tokencounter);
        s_tokencounter++;
    }

    /**
     * @dev Base URI for computing tokenURI.
    */
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }
    /**
      * @dev Returns the token URI with encoded metadata.
     */
    function tokenURI(uint256 /* tokenId */) public view override returns(string memory){
       return 
        string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "FirstNFT',
                            '", "description": "A unique NFT asset.", "image": "',
                            s_secondImageUri,'"}'
                        )
                    )
                )
            )
        );
    }



}