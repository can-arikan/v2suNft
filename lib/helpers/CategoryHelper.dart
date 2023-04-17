import 'package:sunftmobilev3/backend/requests.dart';
import 'package:sunftmobilev3/models/Category.dart';

Future<List<Category>> getCategories(Map<String,dynamic>? query)async {
  List JsonList = await getRequest("categories", query);
  List<Category> categories = JsonList.map((item) => Category.fromJson(item)).toList();
  return categories;
}