import 'dart:math';
import 'dart:typed_data';

/// Generate random key
Uint8List generateKey([int minLen = 64, int maxLen = 2048]) {
  final secureRandom = Random.secure();
  int randomLen = secureRandom.nextInt(maxLen - minLen) + minLen;
  int len = max(randomLen - (randomLen % 64), 64);
  return Uint8List.fromList(
    List<int>.generate(len, (index) => secureRandom.nextInt(256)),
  );
}

/// Encrypt
///
/// [bytes] cleartext
List<int> encrypt(
  List<int> bytes,
  int off,
  int len,
  List<int>? salt,
  int readOffset,
) {
  if (salt == null || salt.isEmpty) {
    return bytes;
  }
  var encoded = List.filled(bytes.length, 0);
  while (off < len) {
    encoded[off] = encryptOne(bytes[off], salt, readOffset);
    off++;
    readOffset++;
  }
  return encoded;
}

/// decrypt
///
/// [bytes] ciphertext
List<int> decrypt(
  List<int> bytes,
  int off,
  int len,
  List<int>? salt,
  int readOffset,
) {
  return encrypt(bytes, off, len, salt, readOffset);
}

int encryptOne(int b, List<int> salt, int readOffset) {
  return b ^ salt[(readOffset + (readOffset ~/ salt.length)) % salt.length];
}

int decryptOne(int b, List<int> salt, int readOffset) {
  return encryptOne(b, salt, readOffset);
}
