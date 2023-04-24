import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;
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

  Future<List<NFT>> get ownedNFTs async {
    var response = (await market_helper.query("fetchMyNFTs", [EthereumAddress.fromHex(address)]))[0];
    var nfts = response.map((e) => NFT(
        address: e["collection_address"],
        nID: e["nID"],
        name: e["collection"],
        description: e["description"],
        metaDataType: "png",
        dataLink: e["tokenId"],
        collectionName: e["collectionName"],
        creator: e["creator"],
        owner: address,
        marketStatus:
        e["marketStatus"])
    );
    return nfts.toList();
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
