import 'dart:typed_data';

/**
 *  1. String              "abc" => 3:abc
 *  2. Int                 123 => i123e
 *  3. List<Object>        List<"abc", 123> => l3:abci123ee
 *  4. Dict<String,Object> Dictionary<{"name":"create chen"},{"age":23}> => d4:name11:create chen3:agei23ee
 */

Uint8List encode(dynamic obj) {
  if (obj is String) {
    return encodeString(obj);
  } else if (obj is int) {
    return encodeInt(obj);
  } else if (obj is Map<String, dynamic>) {
    return encodeDict(obj);
  } else if (obj is List) {
    return encodeList(obj);
  } else {
    return Uint8List.fromList([]);
  }
}

Uint8List encodeString(String str) {
  return Uint8List.fromList("${str.length}:${str}".codeUnits);
}

Uint8List encodeInt(int val) {
  return Uint8List.fromList("i${val}e".codeUnits);
}

Uint8List encodeList(List<dynamic> list) {
  Uint8List inner = list.fold(
      Uint8List.fromList([]),
      (previousValue, element) =>
          Uint8List.fromList([...previousValue, ...encode(element)]));
  return Uint8List.fromList([
    ...Uint8List.fromList("l".codeUnits),
    ...inner,
    ...Uint8List.fromList("e".codeUnits)
  ]);
}

Uint8List encodeDict(Map<String, dynamic> dict) {
  Uint8List inner = dict.entries.fold(
      Uint8List.fromList([]),
      (previousValue, element) => Uint8List.fromList([
            ...previousValue,
            ...encode(element.key),
            ...encode(element.value)
          ]));
  return Uint8List.fromList([
    ...Uint8List.fromList("d".codeUnits),
    ...inner,
    ...Uint8List.fromList("e".codeUnits)
  ]);
}
