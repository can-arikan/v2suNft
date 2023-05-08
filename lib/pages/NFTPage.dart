import 'package:flutter/material.dart';
import 'package:sunftmobilev3/Decoration/AnimatedGradient.dart';
import 'package:sunftmobilev3/decoration/NFTPageDecoration.dart';
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/Decoration/NFTPageDecoration.dart' as decoration;
import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';
import '../providers/ethereumProvider.dart';
import 'SellNFT.dart';

class NFTPage extends StatefulWidget {
  final NFT nftInfo;

  const NFTPage({Key? key, required this.nftInfo}) : super(key: key);

  @override
  NFTPageState createState() => NFTPageState();
}

class NFTPageState extends State<NFTPage> {
  late final BigInt marketId;
  late dynamic marketItems;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      marketItems = (await market_helper.query("fetchAllMarketItems", []))[0];
      marketItems = marketItems.where((item) => item[7] == false).toList();
      for (var itemId = 0; itemId < marketItems.length; itemId++) {
        if (marketItems[itemId][0].toString() == widget.nftInfo.address && marketItems[itemId][3] == widget.nftInfo.tokenId) {
          marketId = BigInt.from(itemId);
        }
      }
    });
    super.initState();
  }

  GestureDetector paymentContainer(String marketStatus, bool isOwner) {
    String textOfBox = marketStatus;
    bool isActive = false;
    if (isOwner && textOfBox == "Not In Market") {
      textOfBox = "Create Market Sale";
      isActive = true;
    } else if (!isOwner && textOfBox == "Not In Market") {
      textOfBox = "This NFT is not on sale";
      isActive = false;
    } else if (isOwner && textOfBox == "In Market") {
      textOfBox = "Cancel Sale";
      isActive = true;
    } else if (!isOwner && textOfBox == "In Market") {
      textOfBox = "Buy This NFT";
      isActive = true;
    }

    return GestureDetector(
      onTap: () async {
        if (isActive) {
          if (textOfBox == "Cancel Sale") {
            var uri = await context.read<EthereumProvider>().getMetamaskUri();
            market_helper.callContract(context, "cancelMarketSale", [marketId], value: EtherAmount.zero());
            await launchUrlString(uri!, mode: LaunchMode.externalApplication);
          }
          else if (textOfBox == "Buy This NFT") {
            var itemPrice = marketItems[marketId.toInt()][6];
            var uri = await context.read<EthereumProvider>().getMetamaskUri();
            market_helper.callContract(context, "createMarketSale", [marketId], value: EtherAmount.inWei(itemPrice));
            await launchUrlString(uri!, mode: LaunchMode.externalApplication);
          }
          else if (textOfBox == "Create Market Sale") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SellNFT(nftInfo: widget.nftInfo,)),
            );
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 6 / 7,
        height: 36,
        margin: const EdgeInsets.all(10),
        decoration: nftMarketStatusBox,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.paid_outlined,
                  color: (isActive ? Colors.white : Colors.grey),
                ),
              ),
            ),
            Center(
                child: Text(
              textOfBox,
              style: decoration.marketStatusTextStyle(isActive),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.nftInfo.name),
          backgroundColor: decoration.appBarColor,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              const Positioned(child: AnimatedGradient()),
              Positioned(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: NetworkImage(widget.nftInfo.dataLink)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Text("Address: ${widget.nftInfo.address}",
                            style: decoration.addressOfNftText),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Text("Likes: ${widget.nftInfo.likeCount}",
                            style: decoration.addressOfNftText),
                      ),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        height: 3,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      paymentContainer(widget.nftInfo.marketStatus,
                          widget.nftInfo.owner == user?.address)
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}
