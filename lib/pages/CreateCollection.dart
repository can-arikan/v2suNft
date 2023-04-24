import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:sunftmobilev3/helpers/marketHelper.dart';
import 'package:sunftmobilev3/models/Category.dart';
import 'package:sunftmobilev3/pages/MainApplication.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';

import '../Decoration/AnimatedGradient.dart';
import 'package:sunftmobilev3/decoration/CreateCollectionDecoration.dart'
    as decoration;

import '../helpers/IpfsLoader.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';
import '../providers/ethereumProvider.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({Key? key}) : super(key: key);

  @override
  _CreateCollectionPageState createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  File? imagePath;
  TextEditingController collectionNameControl = TextEditingController();
  TextEditingController collectionDescriptionControl = TextEditingController();
  TextEditingController collectionSymbolControl = TextEditingController();
  var _selectedCategories;

  Future pickImage(type) async {
    final image = await ImagePicker().pickImage(source: type);
    if (image == null) return;
    setState(() {
      imagePath = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Stack(children: [
        Positioned(child: AnimatedGradient()),
        SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SafeArea(
                  child: Center(
                    child: Stack(
                      children: [
                        Positioned(
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(selectedIndex: 3)),
                              ),
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 16, top: 12),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Create Collection",
                                style: decoration.createCollectionTitle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Create a collection to Mint NFT's from, this action will cost a lot of gas, so you might want to check your wallet balance.",
                    style: decoration.createCollectionDesc,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: TextFormField(
                      style: decoration.collectionTextDecoration,
                      decoration:
                          decoration.collectionContainer("Name of Collecton"),
                      controller: collectionNameControl,
                    )),
                Container(
                    margin: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: TextFormField(
                      style: decoration.collectionTextDecoration,
                      decoration: decoration
                          .collectionContainer("Symbol of Collection"),
                      controller: collectionSymbolControl,
                    )),
                Container(
                    margin: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: TextFormField(
                      style: decoration.collectionTextDecoration,
                      decoration: decoration
                          .collectionContainer("Description of Collection"),
                      controller: collectionDescriptionControl,
                    )),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  child: FutureBuilder<List<Category>>(
                    future: user?.availableCategories,
                    builder: (context, snapshot) {
                      return MultiSelectDialogField(
                        decoration: decoration.imagePickerDecoration,
                        buttonText: Text(
                          "Categories",
                          style: decoration.collectionTextDecoration,
                        ),
                        searchHint: "Categories",
                        searchHintStyle: decoration.collectionTextDecoration,
                        items: snapshot.data != null ? snapshot.data!.map((e) => MultiSelectItem(e.name, e.name)).toList() : <MultiSelectItem>[],
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          _selectedCategories = values;
                        },
                      );
                    }
                  )
                ),
                (imagePath != null)
                    ? SizedBox(
                        width: 100, height: 100, child: Image.file(imagePath!))
                    : Text(
                        "nothing selected",
                        style: decoration.nothingSelectedDecoration,
                      ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () => {pickImage(ImageSource.gallery)},
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 1 / 4,
                      height: 50,
                      decoration: decoration.imagePickerDecoration,
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {pickImage(ImageSource.camera)},
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 1 / 4,
                      height: 50,
                      decoration: decoration.imagePickerDecoration,
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
                ClipRRect(
                  child: GestureDetector(
                    onTap: () async {
                      await createCollection();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(selectedIndex: 3)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      height: 50,
                      alignment: Alignment.bottomRight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF596EED),
                              Color(0xFFED5CAB),
                              //Color(0xFF42A5F5),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                      ),
                      child: Center(
                          child: Text(
                        "Create Collection",
                        style: decoration.createButtonTextStyle,
                      )),
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }

  createCollection() async {
    var ipfsResult = await uploadIpfs(imagePath!);
    ipfsResult = const JsonDecoder().convert(ipfsResult.toString());
    var uri = await context.read<EthereumProvider>().getMetamaskUri();
    dynamic value = (await query("listingPrice", []))[0];
    callContract(context, "createCollection", [
      collectionNameControl.text,
      collectionSymbolControl.text,
      "https://cloudflare-ipfs.com/ipfs/${ipfsResult["Hash"]}",
      collectionDescriptionControl.text,
      _selectedCategories
    ], value: EtherAmount.inWei(value));
    await launchUrlString(uri!, mode: LaunchMode.externalApplication);
  }
}
