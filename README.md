
# NFT MarketTrade Project

## Overview

The **NFT MarketTrade Project** is a decentralized marketplace that allows users to purchase NFTs using a custom ERC20 token. The project integrates four smart contracts:

1. **FirstNFT.sol**: A contract for minting and managing the "FirstNFT" collection.
2. **SecondNFT.sol**: A contract for minting and managing the "SecondNFT" collection.
3. **MyToken.sol**: A custom ERC20 token (`MTK`) used as the payment currency.
4. **TokenTradeMarketplace.sol**: The marketplace contract facilitating the purchase of NFTs using `MTK`.

## Features

- **Custom Token Economy**: Payments for NFTs are made using the custom `MTK` token.
- **Dynamic Pricing**: Owners can set and update the price of each NFT collection.
- **Two NFT Collections**: Supports the purchase of two distinct NFT collections: "FirstNFT" and "SecondNFT".
- **Secure Transactions**: Incorporates OpenZeppelin's `ReentrancyGuard` and access control via `Ownable`.
- **Metadata Encoding**: Uses Base64 encoding for NFT metadata.

## Prerequisites

To deploy and interact with this project, you will need:

- **Node.js** (v16 or higher)
- **Hardhat** or **Foundry** for testing and deployment
- **OpenZeppelin Contracts** for security and standard implementations
- **Forge-Std Library** for debugging and testing

### Installation Steps

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Install dependencies (if applicable):
   ```bash
   npm install
   ```

3. Compile the contracts:
   ```bash
   npx hardhat compile
   ```

## Core Contracts and Functions

### 1. **FirstNFT.sol**

#### Key Functions:
- `mintNFT(address _buyer)`: Mints a new NFT to the buyer. Can only be called by the owner (Marketplace contract).
- `tokenURI(uint256 tokenId)`: Returns the metadata of the NFT, encoded in Base64.

#### Constructor Parameters:
- `firstImageURI`: Base URI for the NFT image.
- `initialOwner`: Initial owner of the contract.

---

### 2. **SecondNFT.sol**

#### Key Functions:
- `mintNFT(address _buyer)`: Similar to `FirstNFT.sol`, mints an NFT to the buyer.
- `tokenURI(uint256 tokenId)`: Returns the metadata of the NFT, encoded in Base64.

#### Constructor Parameters:
- `secondImageURI`: Base URI for the NFT image.
- `initialOwner`: Initial owner of the contract.

---

### 3. **MyToken.sol**

#### Key Functions:
- `constructor(uint256 initialSupply)`: Initializes the token with a specified supply.

#### Token Details:
- Name: `MyToken`
- Symbol: `MTK`

---

### 4. **TokenTradeMarketplace.sol**

#### Key Functions:
- `setPrice(NftChoice choice, uint256 price)`: Allows the owner to set prices for the NFT collections.
- `purchaseNFT(NftChoice choice)`: Facilitates the purchase of an NFT. Validates user balance, transfers tokens, and mints the NFT.
  
#### Events:
- `PriceHasBeenSet`: Emitted when the price of an NFT collection is updated.
- `NFTPurchased`: Emitted when a user successfully purchases an NFT.

#### Constructor Parameters:
- `_paymentToken`: Address of the custom ERC20 token (`MyToken`).
- `_firstNftContract`: Address of the `FirstNFT` contract.
- `_secondNftContract`: Address of the `SecondNFT` contract.

---

### Key Enums and State Variables:
- **`enum NftChoice`**: Represents the choice between `FirstNft` and `SecondNft`.
- **`mapping s_nftChoicePrices`**: Stores the price of each NFT collection.

---

## Usage

1. **Deploy Contracts**:
   - Deploy `MyToken.sol` with an initial supply.
   - Deploy `FirstNFT.sol` and `SecondNFT.sol` with their respective image URIs and owner addresses.
   - Deploy `TokenTradeMarketplace.sol` with the addresses of the above contracts.

2. **Set NFT Prices**:
   The owner sets the price for each collection:
   ```solidity
   marketplace.setPrice(NftChoice.FirstNft, 100 * 1e18);
   marketplace.setPrice(NftChoice.SecondNft, 150 * 1e18);
   ```

3. **Purchase NFTs**:
   Users can purchase NFTs using `MTK`:
   ```solidity
   marketplace.purchaseNFT(NftChoice.FirstNft);
   ```

4. **View Metadata**:
   Retrieve the metadata for an NFT:
   ```solidity
   firstNFT.tokenURI(tokenId);
   ```

## Security

- **Reentrancy Protection**: Prevents malicious reentrant calls during token transfers.
- **Access Control**: Only the owner can set prices and manage the marketplace.
- **Error Handling**: Reverts with custom errors for insufficient balance, transfer failure, or invalid operations.

## License

This project is licensed under the **MIT License**.
