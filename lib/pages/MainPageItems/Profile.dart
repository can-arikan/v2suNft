import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunftmobilev3/components/ListViewContainer.dart';
import "package:sunftmobilev3/decoration/MainPageItemsDecoration/ProfileDecoration.dart"
    as decoration;
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/components/containers/NFTContainer.dart';
import 'package:provider/provider.dart';
import '../../models/User.dart';
import '../../providers/UserProvider.dart';
import '../DepositWithdraw.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Widget dataLoading() {
    return const Padding(
      padding: EdgeInsets.all(40.0),
      child: Center(
          child: SizedBox(
              width: 50, height: 50, child: CircularProgressIndicator())),
    );
  }

  final List<Tab> tabs = const <Tab>[
    Tab(
      icon: Icon(Icons.person),
    ),
    Tab(
      icon: Icon(CupertinoIcons.heart_fill),
    )
  ];

  User? user;
  late TabController _tabController;
  late VoidCallback _handleTabChange;
  late Widget tabView;
  int _index = 0;

  Widget tabBuilder(User user) {
    if (_index == 0) {
      return ListViewContainer<NFT, NFTContainer>(
          parameterizedContainerConstructor:
          NFTContainer.parameterized,
          future: user.ownedNFTs).build(context);
    } else {
      return ListViewContainer<NFT, NFTContainer>(
          parameterizedContainerConstructor:
          NFTContainer.parameterized,
          future: user.likedNFTs).build(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _handleTabChange = () {
      setState(() {
        _index = _tabController.index;
        if (user != null) {
          tabView = tabBuilder(user!);
        } else {
          tabView = dataLoading();
        }
      });
    };
    _tabController.addListener(_handleTabChange);
    tabView = dataLoading();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    tabView = tabBuilder(user!);
    if (user != null) {
      return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 75),
                  padding: const EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: decoration.profileHeaderDecoration,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user!.profilePicture),
                          radius: 50,
                        ),
                      ),
                      Text(
                        user!.address,
                        textAlign: TextAlign.center,
                        style: decoration.profileTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user!.username,
                        textAlign: TextAlign.center,
                        style: decoration.profileTextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        width: MediaQuery.of(context).size.width * 7 / 10,
                        height: 2,
                        color: decoration.dividerColor,
                      ),
                      //balance Sheet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 30,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Likes",
                                    style: decoration.balanceSheetText,
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 20.0),
                                      child: Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text(
                                      user!.nftLikes.toString(),
                                      style: decoration.balanceSheetText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DepositWithdraw()))
                        },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: decoration.depositPageRouterStyle,
                      width: MediaQuery.of(context).size.width * 3 / 4,
                      height: 50,
                      child: Center(
                          child: Text(
                        "Deposit/Withdraw",
                        style: decoration.depositWithdrawTextStyle,
                      )),
                    )),
                TabBar(tabs: tabs, controller: _tabController),
                tabView
              ]));
    } else {
      return noUser(context);
    }
  }
}

Widget noUser(context) {
  return (SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Text(
            "You must Log in to see this page.",
            style: decoration.nonLoginErrorText,
          ),
        ),
        Center(
            child: GestureDetector(
                onTap: () => {
                      Navigator.popAndPushNamed(context, "/Login"),
                    },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    height: 100,
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
                    child: Center(
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: decoration.nonLoginButton,
                      ),
                    ),
                  ),
                )))
      ])));
}
