import 'package:sunftmobilev3/helpers/marketHelper.dart' as MarketHelper;

import 'NftCollection.dart';

class Category {
  String name;
  String backgroundPicture;
  String foregroundPicture;
  Category({required this.name, required this.backgroundPicture, required this.foregroundPicture});

  String get pk => name;

  @override
  String toString() => "Category(name: $name, background: $backgroundPicture, foreground: $foregroundPicture)";

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        name : json['name'],
        backgroundPicture : json['backgroundPicture'],
        foregroundPicture : json['foregroundPicture'],
    );
  }

  @override
  bool operator == (Object rhs) {
    if (rhs is Category) {
      return (rhs.name == name && rhs.foregroundPicture == foregroundPicture
      && rhs.backgroundPicture == backgroundPicture);
    }
    return false;
  }
}