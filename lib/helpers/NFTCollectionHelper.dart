import 'dart:convert';

import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';
import 'package:web3dart/web3dart.dart';
import "package:sunftmobilev3/providers/ethereumProvider.dart" as ethereum_provider;
import "package:sunftmobilev3/ABIs/collectionAbi.dart" as collection_abi;

import '../models/Credentials.dart';

Future<List<NFTCollection>> getTrendingCollections() async {
  List jsonList = (await market_helper.query("getAllCollections", []))[0];
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
  var collections = itemList.map((item) => NFTCollection.fromJson(item)).toList();
  collections.sort((a, b) => a.nftLikes.compareTo(b.nftLikes));
  collections = collections.reversed.toList();
  return collections;
}
Future<List<NFTCollection>> getCollectionsByCategory(String category) async {
  List jsonList = (await market_helper.query("getAllCollections", []))[0];
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
  List<NFTCollection> nfts = itemList.map((item) => NFTCollection.fromJson(item)).toList();
  nfts = nfts.where((element) => element.categories!.contains(category)).toList();
  return nfts;
}

Future<dynamic> callContract(BuildContext context, String functionName, List<dynamic> parameters,
    {EtherAmount? value, required String contractAddress}) async {
  value = value ?? EtherAmount.zero();

  var contract = DeployedContract(ContractAbi.fromJson(const JsonEncoder().convert(collection_abi.abi["ABI"]), "Collection"), EthereumAddress.fromHex(contractAddress));
  var contractFunction = contract.function(functionName);
  var provider = await context.read<ethereum_provider.EthereumProvider>().getProvider();
  provider = provider ?? (throw Exception("Provider Is Not In The Context !!!"));
  var cred = WalletConnectEthereumCredentials(provider: provider);
  List<dynamic> response;
  try {
    var response2 = await ethereum_provider.ethClient.sendTransaction(
        cred,
        Transaction.callContract(
            contract: contract,
            function: contractFunction,
            parameters: parameters,
            from: EthereumAddress.fromHex(
                cred.provider.connector.session.accounts[0]),
            value: value
        ),
        chainId: 80001
    );
    response = response2 as List;
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

Future<dynamic> query(String functionName, List<dynamic> parameters, String contractAddress) async {
  var contract = DeployedContract(ContractAbi.fromJson(const JsonEncoder().convert(collection_abi.abi["ABI"]), "Collection"), EthereumAddress.fromHex(contractAddress));
  var contractFunction = contract.function(functionName);
  List<dynamic> response;
  try {
    response = await ethereum_provider.ethClient.call(contract: contract, function: contractFunction , params: parameters);
  } catch (error, trace) {
    if (kDebugMode) {
      print(error);
    }
    if (kDebugMode) {
      print(trace);
    }
    return null;
  }
  return response;
}