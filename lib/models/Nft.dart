import "../backend/requests.dart";
import 'TransactionHistory.dart';

class NFT {
  final String address;
  final String name;
  final String? description;
  final String dataLink;
  final String collectionName;
  final String creator;
  final String owner;
  final int marketStatus;
  final int tokenId;
  int likeCount;

  NFT({ required this.address, required this.name,
    required this.description,required this.dataLink, required this.tokenId,
    required this.collectionName, required this.creator,required this.owner,
    required this.marketStatus, this.likeCount = 0 });

  Map<String, dynamic> get pk {
    return { "address": address };
  }

  @override
  String toString() => "NFT(address: $address, name: $name, "
      "description: $description, "
      "dataLink: $dataLink, collectionName: $collectionName, "
      "creatorName: creatorName, currentOwner: $owner, "
      "marketStatus: $marketStatus, likeCount: $likeCount)";

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      address: json['address'].toString(),
      tokenId: json["tokenId"],
      name: json['name'],
      description: json['description'],
      dataLink: json['nftFile'],
      collectionName: json['collectionName'],
      creator: json['creator'],
      owner: json['currentOwner'],
      marketStatus: json['marketStatus'],
      likeCount: json["numLikes"],
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'name': name,
    'description': description,
    'dataLink': dataLink,
    'collectionName': collectionName,
    'creatorName': creator,
    'currentOwner': owner,
    'marketStatus': marketStatus,
    'tokenId': tokenId
  };

  @override
  bool operator == (Object other) {
    if (other is NFT) {
      return (other.address == address &&
          other.name == name && other.description == description &&
          other.dataLink == dataLink &&
          other.collectionName == collectionName && other.creator == creator &&
          other.owner == owner && other.marketStatus == marketStatus &&
          other.likeCount == likeCount);
    }
    return false;
  }

  Future<List<TransactionHistory>> get transactionHistory async {
    List JSONList = await getRequest("transactionHistory", pk);
    List<TransactionHistory> history = JSONList.map((item) => TransactionHistory.fromJson(item)).toList();
    history.sort((e1, e2) => e1.date.compareTo(e2.date));
    return history;
  }

}