import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunftmobilev3/Decoration/NFTPageDecoration.dart' as decoration;

import "package:sunftmobilev3/Decoration//RegisterDecoration.dart"
as register_decoration;
import 'package:sunftmobilev3/pages/MainApplication.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../Decoration/AnimatedGradient.dart';
import '../models/Nft.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';
import 'package:sunftmobilev3/helpers/marketHelper.dart' as market_helper;

import '../providers/ethereumProvider.dart';

class SellNFT extends StatefulWidget {
  NFT nftInfo;

  SellNFT({Key? key, required this.nftInfo}) : super(key: key);

  @override
  State<SellNFT> createState() => _SellNFTState();
}

class _SellNFTState extends State<SellNFT> {
  var priceController = TextEditingController();

  SizedBox paymentContainer(User user) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 25, left: 25, right: 25, top: 30),
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: register_decoration.registerFormField,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      controller: priceController,
                      cursorColor: Colors.black87,
                      decoration:
                      register_decoration.priceInputDecoration,
                    ),
                  ),
                  const SizedBox(height: 10),
                  //submit button
                  GestureDetector(
                    onTap: () async {
                      var uri = await context.read<EthereumProvider>().getMetamaskUri();
                      double dPrice = double.parse(priceController.text);
                      int carpan = 1;
                      while (dPrice.toString().substring(dPrice.toString().indexOf(".")) != ".0") {
                        dPrice *= 10;
                        carpan *= 10;
                      }
                      var price = EtherAmount.fromUnitAndValue(EtherUnit.ether, dPrice.toInt().toString()).getInWei;
                      var val = (price / BigInt.from(carpan));
                      price = BigInt.from(val);
                      dynamic value = (await market_helper.query("listingPrice", []))[0];
                      market_helper.callContract(context, "createMarketToken", [EthereumAddress.fromHex(widget.nftInfo.address), widget.nftInfo.tokenId, price], value: EtherAmount.inWei(value));
                      await launchUrlString(uri!, mode: LaunchMode.externalApplication)
                        .whenComplete(() {
                          Navigator.pop(context);
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPage()));
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1 / 2,
                        height: 50,
                        alignment: Alignment.bottomRight,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF596EED),
                                Color(0xFFED5CAB),
                                //Color(0xFF42A5F5),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                        ),
                        child: const Center(
                          child: Text(
                            "Sell",
                            style: register_decoration.registerSubmitButton,
                          ),
                        ),
                      ),
                    ),
                  )
                ]
              ),
            ),
          ),
        ]
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
                          paymentContainer(user!)
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ));
  }
}
