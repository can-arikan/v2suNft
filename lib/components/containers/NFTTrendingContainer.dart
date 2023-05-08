import 'package:flutter/material.dart';
import "package:sunftmobilev3/decoration/ContainerDecoration/NFTCollectionContainerDecoration.dart"
    as decoration;
import 'package:sunftmobilev3/models/Nft.dart';

import '../../pages/NFTPage.dart';

class NFTTrendingContainer extends StatefulWidget {
  const NFTTrendingContainer({Key? key, required this.nft}) : super(key: key);
  final NFT nft;
  const NFTTrendingContainer.parameterized(this.nft, Key? key)
      : super(key: key);
  @override
  NFTTrendingContainerPage createState() => NFTTrendingContainerPage();
}

class NFTTrendingContainerPage extends State<NFTTrendingContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NFTPage(nftInfo: widget.nft)))
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 3 / 4,
        height: MediaQuery.of(context).size.width * 3 / 4,
        decoration: decoration.containerBoxDecoration,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image(
              image: NetworkImage(widget.nft.dataLink),
            ),
          ),
        ),
      ),
    );
  }
}
