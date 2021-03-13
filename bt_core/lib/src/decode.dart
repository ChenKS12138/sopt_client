// /**
//  *  1. String              3:abc => "abc"
//  *  2. Int                 i123e => 123
//  *  3. List<Object>        l3:abci123ee => List<"abc", 123>
//  *  4. Dict<String,Object> d4:name11:create chen3:agei23ee => Dictionary<{"name":"create chen"},{"age":23}>
//  */

/**
 * RuneType
 */
enum RuneType {
  L, // List
  D, // Dict
  I, // Int
  E, // End Of Int List Dict
  DIGIT, // Digit
  COLON, // Colon
  SIGN, // SIGN
}

dynamic decode(Iterator<int> iter) {
  final runeType = runeTypeFromCode(iter.current);
  if (runeType == RuneType.I) {
    return decodeInt(iter);
  } else if (runeType == RuneType.DIGIT) {
    return decodeString(iter);
  } else if (runeType == RuneType.L) {
    return decodeList(iter);
  } else if (runeType == RuneType.D) {
    return decodeDict(iter);
  } else if (runeType == RuneType.E) {
    return null;
  } else {
    throw Error.safeToString("Invalid Builder Start");
  }
}

Map<String, dynamic> decodeDict(Iterator<int> iter) {
  Map<String, dynamic> map = {};
  if (runeTypeFromCode(iter.current) != RuneType.D) {
    throw Error.safeToString("Invalid Dict Start");
  }
  iter.moveNext();
  while (true) {
    if (runeTypeFromCode(iter.current) == RuneType.E) {
      break;
    }
    dynamic key = decode(iter);
    if (key.runtimeType != String) {
      throw Error.safeToString("Invalid Map Key");
    }
    dynamic value = decode(iter);
    map[key] = value;
  }
  iter.moveNext();
  return map;
}

List decodeList(Iterator<int> iter) {
  List list = [];
  if (runeTypeFromCode(iter.current) != RuneType.L) {
    throw Error.safeToString("Invalid List Start");
  }
  iter.moveNext();
  while (true) {
    dynamic item = decode(iter);
    if (item == null) {
      break;
    } else {
      list.add(item);
    }
  }
  iter.moveNext();
  return list;
}

int decodeInt(Iterator<int> iter) {
  if (runeTypeFromCode(iter.current) != RuneType.I) {
    throw Error.safeToString("Invalid Int");
  }
  var intStr = "";
  var endByE = false;
  while (iter.moveNext()) {
    final runeType = runeTypeFromCode(iter.current);
    if (runeType == RuneType.DIGIT || runeType == RuneType.SIGN) {
      intStr += String.fromCharCode(iter.current);
    } else if (runeType == RuneType.E) {
      endByE = true;
      break;
    } else {
      throw Error.safeToString("Invalid Int");
    }
  }
  if (!endByE) {
    throw Error.safeToString("Invalid Int");
  }
  iter.moveNext();
  return int.parse(intStr);
}

String decodeString(Iterator<int> iter) {
  var lenStr = "";
  do {
    final runeType = runeTypeFromCode(iter.current);
    if (runeType == RuneType.DIGIT) {
      lenStr += String.fromCharCode(iter.current);
    } else if (runeType == RuneType.COLON) {
      break;
    } else {
      throw Error.safeToString("Invalid String");
    }
  } while (iter.moveNext());
  int len = int.parse(lenStr);
  var result = "";
  while (iter.moveNext() && len-- > 0) {
    result += String.fromCharCode(iter.current);
  }
  return result;
}

RuneType? runeTypeFromCode(int charCode) {
  if (charCode == 0x3A) {
    return RuneType.COLON;
  } else if (charCode == 0x6C) {
    return RuneType.L;
  } else if (charCode == 0x64) {
    return RuneType.D;
  } else if (charCode == 0x69) {
    return RuneType.I;
  } else if (charCode == 0x65) {
    return RuneType.E;
  } else if (charCode == 0x2D) {
    return RuneType.SIGN;
  } else if (charCode >= 0x30 && charCode < 0x3A) {
    return RuneType.DIGIT;
  } else {
    return null;
  }
}
