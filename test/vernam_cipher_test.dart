import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:vernam_cipher/src/vernam_cipher_algorithm.dart';
import 'package:vernam_cipher/src/vernam_cipher_codec.dart';

void main() async {
  final salt = generateKey();
  final gvCodec = vernamCipher(salt);
  final file = File('./test/assets/dart_async_await.txt');
  final hash = await file.openRead().transform(sha1).first;

  test('Vernam Cipher encrypt+decrypt test', () {
    var plain = 'vernam_cipher'.codeUnits;

    var cipherBytes = encrypt(plain, 0, plain.length, salt, 0);

    var clearBytes = decrypt(cipherBytes, 0, cipherBytes.length, salt, 0);

    expect(cipherBytes.length, plain.length);
    expect(clearBytes, plain);
  });

  test('Vernam Cipher Codec convert test', () {
    final plain = file.readAsStringSync();
    final ciphertext = utf8.fuse(gvCodec).encode(plain);
    final cleartext = utf8.fuse(gvCodec).decode(ciphertext);

    expect(cleartext, plain);
  });

  test('Vernam Cipher Codec stream test', () async {
    final ciphertext = await file
        .openRead()
        .transform(gvCodec.decoder)
        .fold(const <int>[], (previous, element) => [...previous, ...element]);

    final clearHash = await Stream.value(ciphertext)
        .transform(gvCodec.decoder)
        .transform(sha1)
        .first;

    expect(clearHash, hash);
  });
}
