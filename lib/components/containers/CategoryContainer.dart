import 'package:flutter/material.dart';
import "package:sunftmobilev3/decoration/MainPageItemsDecoration/ShowcaseDecoration.dart"
    as decoration;
import 'package:sunftmobilev3/models/Category.dart';
import 'package:sunftmobilev3/pages/CategoryPage.dart';

class CategoryContainer extends StatelessWidget {
  final Category category;
  const CategoryContainer({Key? key, required this.category}) : super(key: key);
  const CategoryContainer.parameterized(this.category, Key? key)
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryPage(category: category)))
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 1 / 3,
        height: MediaQuery.of(context).size.width * 1 / 3,
        decoration: decoration.categoryDecoration,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image(
                image: NetworkImage(category.foregroundPicture),
              ),
            )),
      ),
    );
  }
}
