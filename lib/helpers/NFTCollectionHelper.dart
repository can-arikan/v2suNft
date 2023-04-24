import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sunftmobilev3/backend/requests.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';
import 'package:web3dart/web3dart.dart';
import "package:sunftmobilev3/providers/ethereumProvider.dart" as ethereumProvider;
import "package:sunftmobilev3/ABIs/collectionAbi.dart" as collectionAbi;

import '../models/Credentials.dart';

Future<List<NFTCollection>> getTrendingCollections(Map<String,dynamic>? query)async {
  List JsonList = await getRequest("trending/collection", query);
  List<NFTCollection> collections = JsonList.map((item) => NFTCollection.fromJson(item)).toList();
  return collections;
}
Future<List<NFTCollection>> getNFTsByCategory(Map<String,dynamic>? query) async {
  List JsonList = await getRequest("nftcollections",query);
  List<NFTCollection> nfts = JsonList.map((item) => NFTCollection.fromJson(item)).toList();
  return nfts;
}

Future<dynamic> callContract(BuildContext context, String functionName, List<dynamic> parameters,
    {EtherAmount? value, required String contractAddress}) async {
  value = value ?? EtherAmount.zero();

  var contract = DeployedContract(ContractAbi.fromJson(const JsonEncoder().convert(collectionAbi.abi["ABI"]), "Collection"), EthereumAddress.fromHex(contractAddress));
  var contractFunction = contract.function(functionName);
  var provider = await context.read<ethereumProvider.EthereumProvider>().getProvider();
  provider = provider ?? (throw Exception("Provider Is Not In The Context !!!"));
  var cred = WalletConnectEthereumCredentials(provider: provider);
  List<dynamic> response;
  try {
    var response2 = await ethereumProvider.ethClient.sendTransaction(
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
  var contract = DeployedContract(ContractAbi.fromJson(const JsonEncoder().convert(collectionAbi.abi["ABI"]), "Collection"), EthereumAddress.fromHex(contractAddress));
  var contractFunction = contract.function(functionName);
  List<dynamic> response;
  try {
    response = await ethereumProvider.ethClient.call(contract: ethereumProvider.suNFTmarketContract, function: contractFunction , params: parameters);
  } catch (error, trace) {
    if (kDebugMode) {
      print(error);
    }
    if (kDebugMode) {
      print(trace);
    }
    rethrow;
  }
  return response;
}