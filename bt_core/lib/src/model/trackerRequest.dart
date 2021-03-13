class TrackerRequest {
  // info_hash
  List<int> infoHash;
  // peer_id
  String peerId;
  // String? ip;
  int port;
  String uploaded;
  String downloaded;
  String left;
  String? event;
  TrackerRequest({
    required this.infoHash,
    required this.peerId,
    // this.ip,
    required this.port,
    required this.uploaded,
    required this.downloaded,
    required this.left,
    // required this.event
  });
  String get escapedInfoHash {
    return infoHash.map((e) {
      if ((e >= 0x30 && e < 0x3a) ||
          (e >= 0x61 && e < 0x7B) ||
          (e >= 0x41 && e < 0x5B) ||
          e == 0x2E ||
          e == 0x2D ||
          e == 0x5F ||
          e == 0x7E) {
        return String.fromCharCode(e);
      } else {
        return "%${e.toRadixString(16).padLeft(2, '0')}";
      }
    }).join("");
  }

  String toQueryString() {
    final Map<String, dynamic> query = {
      "info_hash": escapedInfoHash,
      "peer_id": peerId,
      // "ip": ip,
      "port": port.toString(),
      "uploaded": uploaded,
      "downloaded": downloaded,
      "left": left
    };
    return query.entries
        .where((element) => element.value != null)
        .map((e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}")
        .join("&");
  }
}
