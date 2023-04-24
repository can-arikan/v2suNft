import 'package:sunftmobilev3/helpers/marketHelper.dart';
import 'package:sunftmobilev3/models/Category.dart';

Future<List<Category>> getCategories() async {
  List<dynamic> categories = (await query("getCategories", []))[0];
  List<Category> categoriesCast = List.empty(growable: true);
  for (var i = 0; i < categories.length; i++) {
    var category = (await query("getCategoryByName", [categories[i].toString()]));
    Map<String, dynamic> cast = {};
    cast["name"] = category[0];
    cast["foregroundPicture"] = category[1];
    cast["backgroundPicture"] = category[2];
    categoriesCast.add(Category.fromJson(cast));
  }
  return categoriesCast;
}