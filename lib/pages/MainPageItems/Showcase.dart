import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sunftmobilev3/components/Containers/CategoryContainer.dart';
import 'package:sunftmobilev3/components/Containers/NFTTrendingContainer.dart';
import 'package:sunftmobilev3/components/ListViewContainer.dart';
import "package:sunftmobilev3/decoration/MainPageItemsDecoration/ShowcaseDecoration.dart" as decoration;
import "package:sunftmobilev3/components/Containers/NFTCollectionContainer.dart";
import 'package:sunftmobilev3/helpers/CategoryHelper.dart';
import 'package:sunftmobilev3/helpers/NFTCollectionHelper.dart';
import 'package:sunftmobilev3/helpers/NFTHelper.dart';
import 'package:sunftmobilev3/models/Category.dart';
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';
class Showcase extends StatefulWidget {
  const Showcase({Key? key}) : super(key: key);

  @override
  _ShowcaseState createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //categories
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Categories",
              style: decoration.collectionInfoDecoration
            ),
          ),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .width * 1/3,

            child: ListViewContainer<Category,CategoryContainer>(
              parameterizedContainerConstructor: CategoryContainer.parameterized,
              future: getCategories(null),direction: Axis.horizontal,)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Trending Collections",
            style: decoration.collectionInfoDecoration,
            ),
          ),
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 1/3,

              child: ListViewContainer<NFTCollection,NFTCollectionContainer>(
                parameterizedContainerConstructor: NFTCollectionContainer.parameterized,
                future: getTrendingCollections(null),direction: Axis.horizontal,)
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Trending NFT's",
              style: decoration.collectionInfoDecoration,

            ),
          ),
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .width ,

              child: ListViewContainer<NFT,NFTTrendingContainer>(
                parameterizedContainerConstructor: NFTTrendingContainer.parameterized,
                future: getTrendingNFTs(null),direction: Axis.horizontal,)
          ),
        ],
      ),
    );
  }
}
