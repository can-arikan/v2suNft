var abi = {
  "address": "0x6982947e0B522fDA7F5B4b50089b61db15Bd027E".toLowerCase(),
  "ABI": [
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "collectionName",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "collectionSymbol",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "collectionImage",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "description",
          "type": "string"
        },
        {
          "internalType": "string[]",
          "name": "categories",
          "type": "string[]"
        }
      ],
      "name": "createCollection",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "createMarketSale",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "price",
          "type": "uint256"
        }
      ],
      "name": "createMarketToken",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "collectionAddress",
          "type": "address"
        },
        {
          "internalType": "string",
          "name": "tokenUri",
          "type": "string"
        }
      ],
      "name": "createToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "emailAddress",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "pictureUri",
          "type": "string"
        }
      ],
      "name": "createUser",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "deposit",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string[]",
          "name": "categories",
          "type": "string[]"
        },
        {
          "internalType": "string[]",
          "name": "f_pictures",
          "type": "string[]"
        },
        {
          "internalType": "string[]",
          "name": "b_pictures",
          "type": "string[]"
        }
      ],
      "name": "setCategories",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "x",
          "type": "uint256"
        }
      ],
      "name": "setListingPrice",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_userName",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "email",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "pictureUri",
          "type": "string"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "emailAddress",
          "type": "string"
        }
      ],
      "name": "updateUserEmail",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "name",
          "type": "string"
        }
      ],
      "name": "updateUserName",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "pictureUri",
          "type": "string"
        }
      ],
      "name": "updateUserPicture",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "fetchAllMarketItems",
      "outputs": [
        {
          "components": [
            {
              "internalType": "address",
              "name": "collection_address",
              "type": "address"
            },
            {
              "internalType": "string",
              "name": "collection",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "description",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "tokenId",
              "type": "uint256"
            },
            {
              "internalType": "address payable",
              "name": "seller",
              "type": "address"
            },
            {
              "internalType": "address payable",
              "name": "owner",
              "type": "address"
            },
            {
              "internalType": "uint256",
              "name": "price",
              "type": "uint256"
            },
            {
              "internalType": "bool",
              "name": "sold",
              "type": "bool"
            }
          ],
          "internalType": "struct MarketItemHolder.MarketItem[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner_",
          "type": "address"
        },
        {
          "internalType": "string",
          "name": "collectionName",
          "type": "string"
        }
      ],
      "name": "findCollection",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getAllCollections",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "collectionName",
              "type": "string"
            },
            {
              "internalType": "address",
              "name": "collectionAddress",
              "type": "address"
            },
            {
              "internalType": "string",
              "name": "collectionImage",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "collectionDescription",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "collectionLikesCount",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "collectionOwner",
              "type": "address"
            },
            {
              "internalType": "uint256",
              "name": "collectionNftLikes",
              "type": "uint256"
            },
            {
              "internalType": "string[]",
              "name": "categories",
              "type": "string[]"
            }
          ],
          "internalType": "struct CollectionHolder.CollectionJSON[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getAllCollectionsAddresses",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "",
          "type": "address[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getCategories",
      "outputs": [
        {
          "internalType": "string[]",
          "name": "",
          "type": "string[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "catName",
          "type": "string"
        }
      ],
      "name": "getCategoryByName",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getCollectionCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "collectionId",
          "type": "uint256"
        }
      ],
      "name": "getCollectionNftCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getMarketItemCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner_",
          "type": "address"
        }
      ],
      "name": "getMyCollections",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "collectionName",
              "type": "string"
            },
            {
              "internalType": "address",
              "name": "collectionAddress",
              "type": "address"
            },
            {
              "internalType": "string",
              "name": "collectionImage",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "collectionDescription",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "collectionLikesCount",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "collectionOwner",
              "type": "address"
            },
            {
              "internalType": "uint256",
              "name": "collectionNftLikes",
              "type": "uint256"
            },
            {
              "internalType": "string[]",
              "name": "categories",
              "type": "string[]"
            }
          ],
          "internalType": "struct CollectionHolder.CollectionJSON[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "user",
          "type": "address"
        }
      ],
      "name": "getUser",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "userName",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "profilePicture",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "email",
              "type": "string"
            }
          ],
          "internalType": "struct UserHolder.User",
          "name": "",
          "type": "tuple"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "user",
          "type": "address"
        }
      ],
      "name": "getUserLikedCollections",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "user",
          "type": "address"
        }
      ],
      "name": "getUserLikedNFTs",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_address",
          "type": "address"
        }
      ],
      "name": "inCollectionArray",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "listingPrice",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "marketOwner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
};
