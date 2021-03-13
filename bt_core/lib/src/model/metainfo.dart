import 'dart:typed_data';

import 'package:bt_core/core.dart';
import 'package:crypto/crypto.dart';

class Metainfo {
  final String? announce;
  final List<dynamic>? announceList;
  final String? comment;
  final String? commentUtf8;
  final int? creationDate;
  final String? encoding;
  final Info? info;
  // TODO for DHT
  //  dynamic? nodes;
  Metainfo.fromJson(Map<String, dynamic> map)
      : announce = map["announce"],
        announceList = map["announce-list"],
        comment = map["comment"],
        commentUtf8 = map["comment.utf-8"],
        creationDate = map["creation date"],
        encoding = map["encoding"],
        info = Info.fromJson(map["info"]);
  // INFO_HASH
  List<int> get infoHash {
    return sha1.convert(info!.bencoded).bytes;
  }

  @override
  String toString() {
    return "Metainfo {annouce:$announce, annouceList:$announceList, comment:$comment, comment.utf-8:$commentUtf8, creation date:$creationDate, encoding:$encoding, info:$info}";
  }
}

class Info {
  /**
   * multi file
   */
  final List<Fileinfo>? files;
  final String? name;
  final String? nameUtf8;
  final int? pieceLength;
  final String? pieces;
  final String? publisher;
  final String? publisherUtf8;
  final String? publisherUrl;
  final String? publisherUrlUtf8;

  /**
   * single file
   */
  final int? length;
  final Map<String, dynamic> _raw;
  Info.fromJson(Map<String, dynamic> map)
      : _raw = map,
        files = (map["files"] as List<dynamic>)
            .map((e) => Fileinfo.fromJson(e))
            .toList(),
        name = map["name"],
        nameUtf8 = map["name.utf-8"],
        pieceLength = map["piece length"],
        pieces = map["pieces"],
        publisher = map["publisher"],
        publisherUtf8 = map["publisher.utf-8"],
        publisherUrl = map["publisher-url"],
        publisherUrlUtf8 = map["publisher-url.utf-8"],
        length = map["length"];

  @override
  String toString() {
    return "Info {files:$files, name:$name, name.utf-8:$nameUtf8, piece length:$pieceLength, pieces:[fold], publisher:$publisher, publisher.utf-8:$publisherUtf8, publisher-url:$publisherUrl, publisher-url.utf-8: $publisherUrlUtf8}";
  }

  Uint8List get bencoded => encodeDict(_raw);
}

class Fileinfo {
  final int? length;
  final List<dynamic>? path;
  final String? pathUtf8;
  Fileinfo.fromJson(Map<String, dynamic> map)
      : length = map["length"],
        path = map["path"],
        pathUtf8 = map["path.utf-8"];
  @override
  String toString() {
    return "Fileinfo {length:$length, path:$path, path.utf-8:$pathUtf8}";
  }
}
