import 'dart:io';
import 'dart:typed_data';

class TrackerResponse {
  // human readable string which explains why the query failed
  String? failure;
  // maps to the number of seconds the downloader should wait between regular rerequests
  int? interval;
  int? minInterval;
  List<dynamic>? peers;
}

class TrackerResponsePeer {
  String? id;
  String? ip;
  int? port;
  TrackerResponsePeer.fromCompact(Iterator<int> iter) {
    ByteData data = ByteData(6);
    for (var i = 0; i < 6; i++) {
      data.setInt8(i, (iter.current + 128) % 128);
      iter.moveNext();
    }
    ip =
        "${data.getUint8(0)}.${data.getUint8(1)}.${data.getUint8(2)}.${data.getUint8(3)}";
    port = data.getUint16(4);
  }
  static List<TrackerResponsePeer> fromCompacts(String str) {
    final len = (str.codeUnits.length / 6).floor();
    Iterator<int> iter = RuneIterator.at(str, 0);
    List<TrackerResponsePeer> result = [];
    for (var i = 0; i < len; i++) {
      result.add(TrackerResponsePeer.fromCompact(iter));
    }
    return result;
  }

  @override
  String toString() {
    return "TrackerResponsePeer {id:$id, ip:$ip, port: $port}";
  }
}
