import 'package:flutter/material.dart';
import 'package:sunftmobilev3/decoration/AnimatedGradient.dart';
import "package:sunftmobilev3/decoration/DepositWithdrawDecoration.dart" as decoration;
import 'package:sunftmobilev3/models/Nft.dart';
import "package:sunftmobilev3/pages/DepositWithdrawNFT.dart";
class DepositWithdraw extends StatefulWidget {
  const DepositWithdraw({Key? key}) : super(key: key);

  @override
  DepositWithdrawState createState() => DepositWithdrawState();
}

class DepositWithdrawState extends State<DepositWithdraw> {

  NFT? dropDownValue;

  TextEditingController withdrawAmount = TextEditingController();
  TextEditingController depositAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(child: AnimatedGradient()),
          Positioned(child:
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Deposit-Withdraw SU coin and NFT's",
                      style: decoration.depositWithdrawTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //NEW IDEA

                  const Padding(padding: EdgeInsets.only(top:20)),
                  GestureDetector(
                     onTap: ()=>{

                       Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const DepositWithdrawNFT()
                           )
                       )
                     },
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width:  MediaQuery.of(context).size.width * 3/4 ,
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
                            end: Alignment.centerRight
                        ),
                      ),
                      child: Center(
                        child: Text(

                          "Choose a SUNFT to withdraw..",
                          style: decoration.withdrawNFT,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                      ),
                  const Padding(padding: EdgeInsets.all(8)),
                  GestureDetector(
                    onTap: ()=>{

                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width:  MediaQuery.of(context).size.width * 3/4 ,
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
                              end: Alignment.centerRight
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Choose a SUNFT to deposit..",
                            style: decoration.withdrawNFT,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
          ),
        ],
      ),
    );
  }
}
