import 'dart:io';

import 'package:bt_core/src/model/trackerRequest.dart';

Future<List<int>> requestTracker(
    {required HttpClient client,
    required String announce,
    required TrackerRequest param}) async {
  final request =
      await client.getUrl(Uri.parse(announce + "?" + param.toQueryString()));
  final response = await request.close();
  return await response.single;
}
