import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:sunftmobilev3/Decoration/ContainerDecoration/NFTcontainerDecoration.dart"
    as decoration;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:sunftmobilev3/helpers/marketHelper.dart';
import 'package:web3dart/credentials.dart';

import '../../models/Nft.dart';
import '../../models/User.dart';
import '../../pages/NFTPage.dart';
import '../../providers/UserProvider.dart';
import '../../providers/ethereumProvider.dart';

bool oldState = false;

class NFTContainer extends StatefulWidget {
  final NFT nft;
  const NFTContainer({Key? key, required this.nft}) : super(key: key);
  const NFTContainer.parameterized(this.nft, Key? key) : super(key: key);

  @override
  NFTContainerState createState() => NFTContainerState();
}

class NFTContainerState extends State<NFTContainer> {
  bool? userLikedNft;
  void _getUserLikedNft(User user) async {
    var userLike = await user.userLikedNFT(widget.nft);
    setState(() {
      userLikedNft = userLike;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final User? user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        _getUserLikedNft(user);
      }
      var nftLikes = int.parse((await query(
              "getUserLikedNFTs", [EthereumAddress.fromHex(user!.address)]))[0]
          .toString());
      var collectionLikes = int.parse((await query("getUserLikedCollections",
              [EthereumAddress.fromHex(user.address)]))[0]
          .toString());
      setState(() {
        user.nftLikes = nftLikes;
        user.collectionLikes = collectionLikes;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NFTPage(nftInfo: widget.nft)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 7 / 8,
        decoration: decoration.mainBoxDecoration,
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: decoration.NFTimageContainerDecoration,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(widget.nft.dataLink),
                  ),
                )),
            Container(
              decoration: decoration.bottomInfoDecoration,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nft.name,
                        style: decoration.NFTnameDecoration,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.nft.collectionName,
                        style: decoration.NFTcollectionDecoration,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    bool isUserLikedThisNft = userLikedNft!;
                                    setState(() {
                                      if (!userLikedNft!) {
                                        widget.nft.likeCount += 1;
                                        oldState = false;
                                        userLikedNft = !userLikedNft!;
                                      }
                                    });
                                    if (!isUserLikedThisNft) {
                                      var uri = await context
                                          .read<EthereumProvider>()
                                          .getMetamaskUri();
                                      user!.likeNFT(
                                          widget.nft, !userLikedNft!, context);
                                      await launchUrlString(uri!,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Icon(
                                    CupertinoIcons.heart_fill,
                                    color: (userLikedNft == null)
                                        ? ((oldState)
                                            ? Colors.white
                                            : Colors.red)
                                        : (userLikedNft!)
                                            ? Colors.red
                                            : Colors.white,
                                  )),
                              Text(
                                widget.nft.likeCount.toString(),
                                style: decoration.latestPriceDecoration,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
