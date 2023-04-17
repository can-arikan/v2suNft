import 'package:sunftmobilev3/backend/requests.dart';

Future<DateTime?> getCurrentTime() async {
  List JSONResponse = await getRequest("time", null);
  if (JSONResponse.isNotEmpty) {
    DateTime currentTime = DateTime.fromMillisecondsSinceEpoch(JSONResponse[0]["time"]*1000);
    return currentTime;
  }
  return null;
}