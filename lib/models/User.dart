import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;
import 'package:sunftmobilev3/helpers/NFTCollectionHelper.dart' as collection_helper;
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';
import 'package:sunftmobilev3/models/Category.dart' as categories;
import 'package:web3dart/credentials.dart';
import '../backend/requests.dart';

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

  int isInMarket(dynamic market_items, dynamic nft) {
    for (var i = 0; i < market_items.length; i++) {
      if (market_items[i]["collection_address"] == nft["address"] && market_items[i]["tokenId"] == nft["tokenId"]){
        return i;
      }
    }
    return -1;
  }

  Future<List<NFT>> get ownedNFTs async {
    var market_response = (await market_helper.query("getAllCollections", []))[0];
    var all_market_items = (await market_helper.query("fetchAllMarketItems", []))[0];
    List<NFT> nfts = List.empty(growable: true);
    for (var i = 0; i < market_response.length; i++) {
      var response = (await collection_helper.query("getUsersNFTs", [EthereumAddress.fromHex(address)], market_response[i][1]))[0];
      for (var j = 0; j < response.length; j++) {
        dynamic nftLikes = (await collection_helper.query("getNFTsAllLiked", [response[j][1].toInt()], market_response[i][1]))[0];
        dynamic jsonNft = get(response[j][0]);
        dynamic tmpNft = {
          "address": market_response[i][1],
          "tokenId": response[j][1]
        };
        dynamic status = isInMarket(all_market_items, tmpNft);
        status = status != -1 ? all_market_items[i][7] ? "Sold": "Active": "Not In Market";
        NFT tmp = NFT(
            address: market_response[i][1],
            name: jsonNft["name"],
            description: jsonNft["description"],
            dataLink: jsonNft["dataLink"],
            collectionName: market_response[i][0],
            creator: market_response[i][5],
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
    List jsonList = await getRequest("favorites", {"user": pk});
    List<NFT> ownedNFTs = jsonList.map((item) => NFT.fromJson(item)).toList();
    return ownedNFTs;
  }

  Future<bool> userLikedNFT(Map<String, dynamic> nftInfo) async {
    final List jsonList =
        await getRequest("favorites", {...nftInfo, "user": pk});
    return jsonList.isNotEmpty;
  }

  Future<bool> likeNFT(Map<String, dynamic> nftInfo,bool liked) async {
    if(liked){
      return (await deleteRequest("favorites", {...nftInfo, "user": pk}));
    }
    return (await postRequest("favorites", {...nftInfo, "user": pk}));
  }

  Future<bool> userWatchListedCollection(String address) async {
    final List jsonList =
    await getRequest("watchLists", {"nftCollection": address, "user": pk});
    return jsonList.isNotEmpty;
  }

  Future<bool> watchListCollection(String address, bool watchListed) async {
    if(watchListed){
      return (await deleteRequest("watchLists", {"nftCollection": address, "user": pk}));
    }
    return (await postRequest("watchLists", {"nftCollection": address, "user": pk}));
  }

  Future<List<NFTCollection>> get watchlistedCollections async {
    List jsonList = await getRequest("watchLists", {"user": pk});
    if (kDebugMode) {
      print(jsonList);
    }
    List<NFTCollection> watchListedCollections = jsonList.map((item) => NFTCollection.fromJson(item)).toList();

    return watchListedCollections;
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
  Future<bool> watchLists(String address) async {
    List isCollectionFollowed = await getRequest("watchLists", {"user": pk,"nftCollection": address});
    if (kDebugMode) {
      print(isCollectionFollowed);
    }
    return (isCollectionFollowed.isNotEmpty);
  }
}
