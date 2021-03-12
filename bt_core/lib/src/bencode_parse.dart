/**
 *  1. String              "abc" => 3:abc
 *  2. Int                 123 => i123e
 *  3. List<Object>        List<"abc", 123> => l3:abci123ee
 *  4. Dict<String,Object> Dictionary<{"name":"create chen"},{"age":23}> => d4:name11:create chen3:agei23ee
 */

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

dynamic parse(String str) {
  RuneIterator iter = RuneIterator.at(str, 0)..moveNext();
  return builder(iter);
}

dynamic builder(Iterator<int> iter) {
  final runeType = runeTypeFromCode(iter.current);
  if (runeType == RuneType.I) {
    return buildInt(iter);
  } else if (runeType == RuneType.DIGIT) {
    return buildString(iter);
  } else if (runeType == RuneType.L) {
    return buildList(iter);
  } else if (runeType == RuneType.D) {
    return buildDict(iter);
  } else if (runeType == RuneType.E) {
    return null;
  } else {
    throw Error.safeToString("Invalid Builder Start");
  }
}

Map buildDict(Iterator<int> iter) {
  Map map = {};
  if (runeTypeFromCode(iter.current) != RuneType.D) {
    throw Error.safeToString("Invalid Dict Start");
  }
  iter.moveNext();
  while (true) {
    if (runeTypeFromCode(iter.current) == RuneType.E) {
      break;
    }
    dynamic key = builder(iter);

    if (key.runtimeType != String) {
      throw Error.safeToString("Invalid Map Key");
    }
    dynamic value = builder(iter);
    map[key] = value;
  }
  iter.moveNext();
  return map;
}

List buildList(Iterator<int> iter) {
  List list = [];
  if (runeTypeFromCode(iter.current) != RuneType.L) {
    throw Error.safeToString("Invalid List Start");
  }
  iter.moveNext();
  while (true) {
    dynamic item = builder(iter);
    if (item == null) {
      break;
    } else {
      list.add(item);
    }
  }
  iter.moveNext();
  return list;
}

int buildInt(Iterator<int> iter) {
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

String buildString(Iterator<int> iter) {
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
