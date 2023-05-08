import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;
import 'package:sunftmobilev3/helpers/NFTCollectionHelper.dart' as collection_helper;
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';
import 'package:sunftmobilev3/models/Category.dart' as categories;
import 'package:web3dart/credentials.dart';

class User {
  final String address;
  final String username;
  final String profilePicture;
  final String email;
  int nftLikes;
  int collectionLikes;

  User(
      {required this.address,
      required this.username,
      required this.profilePicture,
      required this.email,
      required this.nftLikes,
      required this.collectionLikes});

  String get pk => address;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        address: json['uAddress'],
        username: json['username'],
        profilePicture: json['profilePicture'] ?? "https://ia801703.us.archive.org/6/items/twitter-default-pfp/e.png",
        email: json['email'],
        nftLikes: json['NFTLikes'],
        collectionLikes: json["collectionLikes"]);
  }

  @override
  String toString() =>
      "User(address: $address, username: $username, profilePicture: $profilePicture, email: $email, NFTLikes: $nftLikes, collectionLikes: $collectionLikes)";

  int isInMarket(dynamic marketItems, dynamic nft) {
    for (var i = 0; i < marketItems.length; i++) {
      if (marketItems[i][0].toString() == nft["address"] && marketItems[i][3] == nft["tokenId"] && marketItems[i][7] == false){
        return i;
      }
    }
    return -1;
  }

  Future<List<NFT>> get ownedNFTs async {
    var marketResponse = (await market_helper.query("getAllCollections", []))[0];
    var allMarketItems = (await market_helper.query("fetchAllMarketItems", []))[0];
    List<NFT> nfts = List.empty(growable: true);
    for (var i = 0; i < marketResponse.length; i++) {
      var response = (await collection_helper.query("getUserNFTs", [EthereumAddress.fromHex(address)], marketResponse[i][1].toString()))[0];
      for (var j = 0; j < response.length; j++) {
        dynamic nftLikes = (await collection_helper.query("getNFTsAllLiked", [response[j][1]], marketResponse[i][1].toString()))[0].length;
        dynamic jsonNft = const JsonDecoder().convert((await get(Uri.parse(response[j][0]))).body);
        dynamic tmpNft = {
          "address": marketResponse[i][1].toString(),
          "tokenId": response[j][1]
        };
        dynamic status = isInMarket(allMarketItems, tmpNft);
        status = (status != -1 ? "In Market" : "Not In Market");
        NFT tmp = NFT(
            address: marketResponse[i][1].toString(),
            name: jsonNft["name"],
            description: jsonNft["description"],
            dataLink: jsonNft["image"],
            collectionName: marketResponse[i][0],
            creator: marketResponse[i][5].toString(),
            owner: address,
            tokenId: response[j][1],
            marketStatus: status,
            likeCount: nftLikes
          );
        nfts.add(tmp);
      }
    }
    return nfts;
  }

  Future<List<NFT>> get likedNFTs async {
    return await getAllUserLikedNfts();
  }

  Future<List<NFT>> getAllUserLikedNfts() async {
    var allMarketItems = (await market_helper.query("fetchAllMarketItems", []))[0];
    var collections = (await market_helper.query("getAllCollectionsAddresses", []))[0];
    List<NFT> nfts = List.empty(growable: true);
    for (var i in collections) {
      var tokenCount = (await collection_helper.query("currentTokenId", [], i.toString()))[0];
      for (var tokenId = 0; tokenId < int.parse(tokenCount.toString()); tokenId++){
        var nftWebAddress = (await collection_helper.query("tokenURI", [BigInt.from(tokenId)], i.toString()))[0];
        dynamic jsonNft = const JsonDecoder().convert((await get(Uri.parse(nftWebAddress))).body);
        dynamic tmpNft = {
          "address": i.toString(),
          "tokenId": tokenId
        };
        var collectionName = (await collection_helper.query("name", [], i.toString()))[0];
        var nftOwner = (await collection_helper.query("ownerOf", [BigInt.from(tokenId)], i.toString()))[0];
        dynamic status = isInMarket(allMarketItems, tmpNft);
        status = status != -1 ? "In Market" : "Not In Market";
        var likers = (await collection_helper.query("getAllLiked", [], i.toString()))[0];
        dynamic nftLikes = (await collection_helper.query("getNFTsAllLiked", [BigInt.from(tokenId)], i.toString()))[0].length;
        bool isUserLiked = likers.contains(i);
        if (isUserLiked) {
          nfts.add(
            NFT(
              address: i.toString(),
              name: jsonNft["name"],
              description: jsonNft["description"],
              dataLink: jsonNft["image"],
              tokenId: BigInt.from(tokenId),
              collectionName: collectionName,
              creator: nftOwner,
              owner: address,
              marketStatus: status,
              likeCount: nftLikes
            )
          );
        }
      }
    }
    return nfts;
  }
  
  Future<List> getUserLikedNfts(NFT nft) async {
    List likedAddresses = (await collection_helper.query("getNFTsAllLiked", [nft.tokenId], nft.address))[0];
    return likedAddresses.where((element) => element.toString() == address).toList();
  }

  Future<bool> userLikedNFT(NFT nftInfo) async {
    var jsonList = await getUserLikedNfts(nftInfo);
    return jsonList.isNotEmpty;
  }

  Future<bool> likeNFT(NFT nftInfo,bool liked, BuildContext context) async {
    try {
      await
      await collection_helper.callContract(context, "likeNFT", [nftInfo.tokenId], contractAddress: nftInfo.address);
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<List<NFTCollection>> get ownedCollections async {
    dynamic jsonList = (await market_helper.query("getMyCollections", [EthereumAddress.fromHex(address)])
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    }))[0];
    List<Map<String, dynamic>> itemList = List.empty(growable: true);
    for (var i = 0; i < jsonList.length; i++){
      Map<String, dynamic> convert = {};
      convert["address"] = jsonList[i][1];
      convert["name"] = jsonList[i][0];
      convert["collectionImage"] = jsonList[i][2];
      convert["description"] = jsonList[i][3];
      convert["numLikes"] = jsonList[i][4];
      convert["owner"] = jsonList[i][5];
      convert["categories"] = jsonList[i][7];
      convert["nftLikes"] = jsonList[i][6];
      itemList.add(convert);
    }
    List<NFTCollection> ownedCollections = itemList.map((item) => NFTCollection.fromJson(item)).toList();
    return ownedCollections;
  }

  Future<List<categories.Category>> get availableCategories async {
    dynamic response = await market_helper.query("getCategories", [])
    .onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
    dynamic categoryNames = response[0];
    List<categories.Category> cats = List.empty(growable: true);
    for (var e in categoryNames) {
      dynamic categoryVars = await market_helper.query("getCategoryByName", [e.toString()])
          .onError((error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }
      });
      var newCat = categories.Category(
          name: categoryVars[0],
          backgroundPicture: categoryVars[1],
          foregroundPicture: categoryVars[2]
      );
      cats.add(newCat);
    }
    return cats;
  }
}
