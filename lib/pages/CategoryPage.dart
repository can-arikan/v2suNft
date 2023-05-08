import 'package:flutter/material.dart';
import 'package:sunftmobilev3/components/Containers/NFTCollectionContainer.dart';
import 'package:sunftmobilev3/decoration/AnimatedGradient.dart';
import "package:sunftmobilev3/decoration/CategoryPageDecoration.dart"
    as decoration;
import 'package:sunftmobilev3/models/Category.dart';
import 'package:sunftmobilev3/models/NftCollection.dart';

import '../components/ListViewContainer.dart';
import '../helpers/NFTCollectionHelper.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);
  final Category category;
  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const Positioned(child: AnimatedGradient()),
        Positioned(
            child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: decoration.categoryImageDecoration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned(
                              child: SizedBox(
                            width: double.infinity,
                            child: Image(
                              image: NetworkImage(
                                  widget.category.backgroundPicture),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )),
                          SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.category.foregroundPicture),
                                    radius: 50,
                                  ))),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(20),
                            decoration: decoration.categoryNameBoxDecoration,
                            child: Center(
                              child: Text(
                                "${widget.category.name} Collections",
                                style: decoration.categoryImageTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child:
                    ListViewContainer<NFTCollection, NFTCollectionContainer>(
                        parameterizedContainerConstructor:
                        NFTCollectionContainer.parameterized,
                        future: getCollectionsByCategory(widget.category.name)),),
              ],
            ),
          ),
        ))
      ],
    ));
  }
}
