import 'package:sunftmobilev3/backend/requests.dart';
import 'package:sunftmobilev3/models/Nft.dart';

Future<List<NFT>> getTrendingNFTs(Map<String,dynamic>? query)async {
  List JsonList = await getRequest("trending/nft", query);
  List<NFT> nfts = JsonList.map((item) => NFT.fromJson(item)).toList();
  return nfts;
}

Future<List<NFT>> getNFTsByCollection(Map<String,dynamic>? query) async {
  List JsonList = await getRequest("nfts",query);
  List<NFT> nfts = JsonList.map((item) => NFT.fromJson(item)).toList();
  return nfts;
}
