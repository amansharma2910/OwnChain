// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;


contract OwnChain {

    struct Ownership {
        address ownerAddress;
        uint datePurchased;
    }

    struct Asset {
        string name;
        string brand;
        string serialNumber;
        string purchaseRecord;
        address latestOwner;
        bool isOnSale;
    }

    mapping (string => Asset) public assets;
    mapping (string => Ownership[]) public OwnershipRecord;

    // function getAllAssets() public view returns (string[]) {}
    
    
    struct Offer {
        uint256 offer;
        address buyerAddress;
        bool approved;
        bool completed;
    }

    mapping (string => Offer) public offers;

    struct Withdraw {
        address sellerAddress;
        uint256 amount;
    }

    mapping (string => Withdraw) private withdrawals;

    event AssetRecordCreated(string serialNumber, address owner);
    function createAssetRecord(string memory name, string memory brand, string memory serialNumber, string memory purchaseRecord) public {
        // Ensure asset does not already exist
        require(bytes(assets[serialNumber].name).length == 0);

        // Create asset record
        assets[serialNumber] = Asset(name, brand, serialNumber, purchaseRecord, msg.sender, false);

        createOwnershipRecord(serialNumber, msg.sender);
        emit AssetRecordCreated(serialNumber, msg.sender);
    }


    function createOwnershipRecord(string memory serialNumber, address newOwner) private {
        // Ensure asset exists
        require(bytes(assets[serialNumber].name).length != 0);

        // Create ownership record
        OwnershipRecord[serialNumber].push(Ownership(newOwner, block.timestamp));
        assets[serialNumber].latestOwner = newOwner;
        assets[serialNumber].isOnSale = false;
    }

    event AssetMarkedOnSale(string serialNumber, address owner);
    function setAssetOnSale(string memory serialNumber) public {
        require(assets[serialNumber].latestOwner == msg.sender);

        // Set asset on sale
        assets[serialNumber].isOnSale = true;
        emit AssetMarkedOnSale(serialNumber, msg.sender);
    }


    event AssetMarkedOffSale(string serialNumber, address owner);
    function setAssetOffSale(string memory serialNumber) public {
        require(assets[serialNumber].latestOwner == msg.sender);

        // Set asset off sale
        assets[serialNumber].isOnSale = false;
        emit AssetMarkedOffSale(serialNumber, msg.sender);
    }

    event OfferCreated(string serialNumber, address owner, address buyer);
    function createOffer(string memory serialNumber, uint offer) public {
        require(assets[serialNumber].isOnSale == true);
        require(offer > offers[serialNumber].offer);

        // create offer
        offers[serialNumber] = Offer(offer, msg.sender, false, false);
        emit OfferCreated(serialNumber, assets[serialNumber].latestOwner, msg.sender);
    }


    event OfferApproved(string serialNumber, address owner, address buyer);
    function approveOffer(string memory serialNumber) public { 
        require(msg.sender == assets[serialNumber].latestOwner);
        require(assets[serialNumber].isOnSale == true);

        offers[serialNumber].approved = true;
        emit OfferApproved(serialNumber, assets[serialNumber].latestOwner, msg.sender);
    }


    receive() external payable {}

    
    event PaidForAsset(string serialNumber, address previousOwner, address newOwner);
    function payForAsset(string memory serialNumber) external payable {
        require(offers[serialNumber].approved == true);
        require(offers[serialNumber].buyerAddress == msg.sender);
        require(msg.sender.balance > msg.value);
        require(msg.value > offers[serialNumber].offer);

        offers[serialNumber].completed == true;
        withdrawals[serialNumber] = Withdraw(assets[serialNumber].latestOwner, msg.value);
        assets[serialNumber].latestOwner = msg.sender;
        emit PaidForAsset(serialNumber, withdrawals[serialNumber].sellerAddress, msg.sender);
    }


    event WithdrawBidAmound(string serialNumber, address withdrawer, uint amount);
    function withdraw(string memory serialNumber) external payable returns (bool) {
        require(msg.sender == withdrawals[serialNumber].sellerAddress);
        uint amount = withdrawals[serialNumber].amount;

        if (amount > 0) {
            if (!payable(msg.sender).send(amount)) {
                // No need to call throw here, just reset the amount owing
                withdrawals[serialNumber].amount = 0;
                return false;
            }
        }
        emit WithdrawBidAmound(serialNumber, withdrawals[serialNumber].sellerAddress, amount);
        return true;
    }
}