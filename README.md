[![pub package](https://img.shields.io/pub/v/vernam_cipher.svg)](https://pub.dev/packages/vernam_cipher)

Dart implementation of Vernam Cipher.

## Usage

```dart
var vernam = vernamCipher(); // optional key
var encoded = vernam.encode(utf8.encode('This is example.'));
var cleartext = vernam.decode(encoded);
```

Encryption and decryption in the form of streams:

```dart
final enStream =
      Stream.value(utf8.encode('This is example.')).transform(vernam.encoder);

  var output = File('path/to/file').openWrite();
  await output.addStream(enStream);
  output.close();

  var input = File('path/to/file').openRead();
  var cleartext = await input
      .transform(vernam.decoder)
      .transform(utf8.decoder)
      .fold(StringBuffer(),
          (StringBuffer buffer, String string) => buffer..write(string))
      .then((StringBuffer buffer) => buffer.toString());
```