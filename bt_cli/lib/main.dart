import 'dart:io';

import "package:bt_core/core.dart" as core;

void main(List<String> args) async {
  var file = File("BlueArchive.torrent");
  var bytes = file.readAsBytesSync();
  Map<String, dynamic> map = core.decode(bytes.iterator..moveNext());
  core.Metainfo metainfo = core.Metainfo.fromJson(map);
  core.TrackerRequest param = core.TrackerRequest(
      infoHash: metainfo.infoHash,
      peerId: "-qB4330-lgx3V4jQ8uDM",
      port: 1,
      uploaded: "0",
      downloaded: "0",
      left: "11635970");
  HttpClient client = HttpClient();
  client.autoUncompress = true;
  final list = await core.requestTracker(
      client: client,
      announce: "http://t.nyaatracker.com/announce",
      param: param);
  Map<String, dynamic> trackerMap = core.decode(list.iterator..moveNext());
  print(core.TrackerResponsePeer.fromCompacts(trackerMap["peers"]));
}
