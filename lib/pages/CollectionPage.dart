import 'package:flutter/material.dart';
import 'package:sunftmobilev3/components/Containers/NFTContainer.dart';
import 'package:sunftmobilev3/helpers/NFTHelper.dart';
import 'package:sunftmobilev3/helpers/UserHelper.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';
import 'package:sunftmobilev3/decoration/AnimatedGradient.dart';
import 'package:sunftmobilev3/decoration/CollectionPageDecoration.dart'
    as decoration;
import 'package:provider/provider.dart';

import '../components/ListViewContainer.dart';
import '../models/Nft.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key, required this.collectionInfo})
      : super(key: key);
  final NFTCollection collectionInfo;
  @override
  CollectionPageState createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage> {
  bool expandPressed = false;
  bool? userFollowsThis;
  void _getUserFollowedCollection(user) async {
    var userLike = await user?.watchLists(widget.collectionInfo.address!);
    setState(() {
      userFollowsThis = userLike;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final User? user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        _getUserFollowedCollection(user);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: AnimatedGradient(),
            ),
            Positioned(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            child: Image(
                                image: NetworkImage(
                                    widget.collectionInfo.collectionImage)),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: decoration.collectionNameBoxDecoration,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.collectionInfo.name,
                                style: decoration.collectionNameTextStyle,
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Watchlist: ${widget.collectionInfo.numLikes}",
                                style: decoration.collectionNameTextStyle,
                              ),
                              Text(
                                "Likes: ${widget.collectionInfo.nftLikes}",
                                style: decoration.collectionNameTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        if (userFollowsThis != null)
                          {
                            user!.watchListCollection(
                                widget.collectionInfo.address!,
                                userFollowsThis!)
                          }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        height: 30,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: decoration.collectionNameBoxDecoration,
                        child: Text(
                          (userFollowsThis != null)
                              ? ((userFollowsThis!)
                                  ? "Remove this collection from watchlist"
                                  : "watchlist this collection")
                              : "Loading",
                          style: decoration.collectionDescriptionTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: widget.collectionInfo.description != null
                          ? (widget.collectionInfo.description!.length <= 100 ||
                                  expandPressed)
                              ? Text(
                                  "Description: \n\n${widget.collectionInfo.description!}",
                                  style:
                                      decoration.collectionDescriptionTextStyle,
                                )
                              : GestureDetector(
                                  child: Text(
                                    "Description: \n\n${widget.collectionInfo.description!
                                            .substring(0, 100)}...",
                                    style: decoration
                                        .collectionDescriptionTextStyle,
                                  ),
                                  onTap: () => setState(() {
                                        expandPressed = true;
                                      }))
                          : Text(
                              "No description provided by owner",
                              style: decoration.collectionDescriptionTextStyle,
                            ),
                    ),
                    Container(
                      decoration: decoration.collectionOwnerBoxDecoration,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Created by: ${widget.collectionInfo.owner}",
                            style: decoration.collectionOwnerTextStyle,
                          ),
                          FutureBuilder<User?>(
                              future: getUser(
                                  username: widget.collectionInfo.owner),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.profilePicture),
                                  );
                                } else {
                                  return const CircleAvatar();
                                }
                              }),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Items in this collection:",
                          style: decoration.collectionItemsTextStyle,
                        )),
                    ListViewContainer<NFT, NFTContainer>(
                      parameterizedContainerConstructor:
                          NFTContainer.parameterized,
                      future: getNFTsByCollection(
                          {"collection": widget.collectionInfo.address}),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
