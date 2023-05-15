import 'dart:convert';

import 'package:http/http.dart';
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/helpers/NFTCollectionHelper.dart' as collection_helper;
import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;

import '../models/NftCollection.dart';

int isInMarket(dynamic marketItems, dynamic nft) {
  for (var i = 0; i < marketItems.length; i++) {
    if (marketItems[i][0].toString() == nft["address"] && marketItems[i][3] == BigInt.from(nft["tokenId"]) && marketItems[i][7] == false){
      return i;
    }
  }
  return -1;
}

Future<List<NFT>> getTrendingNFTs({String? collectionAddress}) async {
  List jsonList = (await market_helper.query("getAllCollections", []))[0];
  List allMarketItems = (await market_helper.query(
      "fetchAllMarketItems", []))[0];
  List<Map<String, dynamic>> itemList = List.empty(growable: true);
  for (var i = 0; i < jsonList.length; i++) {
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
  List<NFTCollection> collections = itemList.map((item) =>
      NFTCollection.fromJson(item)).toList();
  if (collectionAddress != null) {
    collections = collections.where((element) => element.address == collectionAddress).toList();
  }
  List<NFT> nfts = List.empty(growable: true);
  for (var collection in collections) {
    var tokenCount = (await collection_helper.query(
        "currentTokenId", [], collection.address!))[0];
    for (var tokenId = 0; tokenId < int.parse(tokenCount.toString()); tokenId++) {
      var nftWebAddress = (await collection_helper.query(
          "tokenURI", [BigInt.from(tokenId)], collection.address!))[0];
      dynamic jsonNft = const JsonDecoder().convert(
          (await get(Uri.parse(nftWebAddress))).body);
      dynamic tmpNft = {
        "address": collection.address.toString(),
        "tokenId": tokenId
      };
      var collectionName = (await collection_helper.query(
          "name", [], collection.address!))[0];
      var nftOwner = (await collection_helper.query(
          "ownerOf", [BigInt.from(tokenId)], collection.address!))[0];
      var marketIdx = isInMarket(allMarketItems, tmpNft);
      var status = (marketIdx != -1 ? "In Market" : "Not In Market");
      var bigTokenId = BigInt.from(tokenId);
      dynamic nftLikes = (await collection_helper.query("getNFTsAllLiked", [bigTokenId], collection.address!))[0].length;
      nfts.add(
          NFT(
            address: collection.address!,
            name: jsonNft["name"],
            description: jsonNft["description"],
            dataLink: jsonNft["image"],
            tokenId: bigTokenId,
            collectionName: collectionName,
            creator: collection.owner,
            owner: (marketIdx != -1 ? allMarketItems[marketIdx][4].toString() : nftOwner.toString()),
            marketStatus: status,
            likeCount: nftLikes
          )
      );
    }
  }
  nfts = nfts.where((nft) => nft.marketStatus == "In Market").toList();
  nfts.sort((a, b) => a.likeCount.compareTo(b.likeCount));
  nfts = nfts.reversed.toList();
  return nfts;
}

Future<List<NFT>> getNFTsByCollection(String collectionAddress) async {
  var nfts = await getTrendingNFTs(collectionAddress: collectionAddress);
  return nfts;
}
