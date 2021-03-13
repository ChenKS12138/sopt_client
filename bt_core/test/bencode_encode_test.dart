import 'package:bt_core/core.dart';
import 'package:test/test.dart';

void main() {
  test("string encode", () {
    expect(encodeString("announce"), equals("8:announce"));
  });
  test("int encode", () {
    expect(encodeInt(123), equals("i123e"));
  });
  test("list encode", () {
    expect(encodeList([1, 2, 3]), equals("li1ei2ei3ee"));
  });
  test("dict encode", () {
    expect(encodeDict({"name": "chen", "age": 20}),
        equals("d4:name4:chen3:agei20ee"));
  });
}
