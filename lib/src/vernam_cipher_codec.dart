import 'dart:convert';
import 'dart:core';

import 'vernam_cipher_algorithm.dart';

/// Get a VernamCipherCodec
///
/// [key] If no key is specified, it will be randomly generated
VernamCipherCodec vernamCipher([List<int>? key]) =>
    VernamCipherCodec(key ?? generateKey());

typedef Ciphertext = List<int>;
typedef Cleartext = List<int>;

class VernamCipherCodec extends Codec<Cleartext, Ciphertext> {
  final List<int> key;

  const VernamCipherCodec(this.key);

  @override
  Converter<Ciphertext, Cleartext> get decoder => VernamCipherDecoder(key);

  @override
  Converter<Cleartext, Ciphertext> get encoder => VernamCipherEncoder(key);
}

class VernamCipherEncoder extends Converter<Cleartext, Ciphertext> {
  final List<int> key;

  const VernamCipherEncoder(this.key);

  @override
  Cleartext convert(Cleartext input) => encrypt(input, 0, input.length, key, 0);

  @override
  Sink<Cleartext> startChunkedConversion(Sink<Ciphertext> sink) =>
      _GilbertVernamEncodeSink(key, sink);
}

class VernamCipherDecoder extends Converter<Ciphertext, Cleartext> {
  final List<int> key;

  const VernamCipherDecoder(this.key);

  @override
  Cleartext convert(Ciphertext input) =>
      decrypt(input, 0, input.length, key, 0);

  @override
  Sink<Ciphertext> startChunkedConversion(Sink<Cleartext> sink) =>
      _GilbertVernamDecodeSink(key, sink);
}

class _GilbertVernamDecodeSink extends ByteConversionSinkBase {
  final Sink<Cleartext> _sink;
  final List<int> _key;
  int _offset = 0;

  _GilbertVernamDecodeSink(this._key, this._sink);

  @override
  void add(Ciphertext bytes) {
    final decoded = decrypt(bytes, 0, bytes.length, _key, _offset);
    _offset += decoded.length;
    _sink.add(decoded);
  }

  @override
  void close() {
    _offset = 0;
    _sink.close();
  }
}

class _GilbertVernamEncodeSink extends ByteConversionSinkBase {
  final List<int> _key;
  final Sink<Ciphertext> _sink;
  int _offset = 0;

  _GilbertVernamEncodeSink(this._key, this._sink);

  @override
  void add(Cleartext bytes) {
    var encoded = encrypt(bytes, 0, bytes.length, _key, _offset);
    _offset += encoded.length;
    _sink.add(encoded);
  }

  @override
  void close() {
    _offset = 0;
    _sink.close();
  }
}
