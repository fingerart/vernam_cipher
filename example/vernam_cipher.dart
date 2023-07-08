import 'dart:convert';

import 'package:vernam_cipher/vernam_cipher.dart';

Future<void> main(List<String> arguments) async {
  var vernam = vernamCipher();
  var encoded = vernam.encode(utf8.encode('This is example.'));
  print(vernam.key);
  print(encoded);

  var cleartext = utf8.decode(vernam.decode(encoded));
  print(cleartext);
}
