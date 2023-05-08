import 'package:flutter/foundation.dart';
import 'package:web3dart/contracts.dart';

import "package:sunftmobilev3/providers/ethereumProvider.dart" as ethereum_provider;

Future<dynamic> query(DeployedContract collectionContract, String functionName, List<dynamic> parameters) async {
  collectionContract = collectionContract;

  var contractFunction =  collectionContract.function(functionName);
  List<dynamic> response;
  try {
    response = await ethereum_provider.ethClient.call(contract: ethereum_provider.suNFTmarketContract, function: contractFunction , params: parameters);
  } catch (error, trace) {
    if (kDebugMode) {
      print(error);
    }
    if (kDebugMode) {
      print(trace);
    }
    rethrow;
  }
  return response[0].toString();
}

class NFTCollection {
  final String? address;
  final String name;
  final String? description;
  final String collectionImage;
  final String owner;
  int numLikes;
  final List<String>? categories;
  int nftLikes;

  String? get pk => address;

  NFTCollection({ this.address, required this.name, required this.description,
    required this.collectionImage,required this.categories, this.numLikes = 0,
    this.nftLikes = 0, required this.owner });

  // Future<NFTCollection> fromContractAddress(String address) async {
  //   DeployedContract collectionContract = DeployedContract(ContractAbi.fromJson(const JsonEncoder().convert(CollectionAbi.abi["ABI"]), "collectionContract"), EthereumAddress.fromHex(address));
  //   await query(collectionContract, "", []);
  //
  //   return NFTCollection();
  // }

  factory NFTCollection.fromJson(Map<String, dynamic> json) {
    List<String> categories = List.empty(growable: true);
    for (var i = 0; i < json["categories"].length; i++){
      categories.add(json["categories"][i].toString());
    }
    return NFTCollection(
      address: json["address"].toString(),
      name: json["name"].toString(),
      collectionImage: json["collectionImage"].toString(),
      description: json["description"].toString(),
      numLikes: json["numLikes"].toInt(),
      owner: json["owner"].toString(),
      categories: categories,
      nftLikes: json["nftLikes"].toInt()
    );
  }


  Map<String, dynamic> toJson() => {
    'address': address,
    'name': name,
    'description': description,
    'collectionImage':collectionImage,
    'numLikes': numLikes,
    'owner': owner,
    'categories': categories,
    "NFTLikes": nftLikes,
  };

  @override
  String toString() => "NFTCollection(address: $address, name: $name, description: $description, collectionImage: $collectionImage, numLikes: $numLikes, owner: $owner, categories: $categories, NFTLikes: $nftLikes)";

}