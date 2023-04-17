import 'package:sunftmobilev3/backend/requests.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';

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