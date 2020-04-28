import 'dart:typed_data';
import 'dart:math';
import 'dart:convert' show utf8;
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/pointycastle.dart';
import "package:pointycastle/export.dart";
import 'package:rsa_encrypt/rsa_encrypt.dart';

/*
  Public / Private key encryption methods
  Thanks to:
    - https://stackoverflow.com/questions/52702423/flutter-how-to-generate-a-private-public-key-pair-to-encrypt-messages
    - https://medium.com/flutter-community/asymmetric-key-generation-in-flutter-ad2b912f3309
 */

class Encrypt {
  AsymmetricKeyPair generateKeyPair() {
    var keyParams = new RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
    var secureRandom = new FortunaRandom();
    var random = new Random.secure();

    List<int> seeds = [];

    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }

    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));

    var rngParams = new ParametersWithRandom(keyParams, secureRandom);
    var k = new RSAKeyGenerator();
    k.init(rngParams);

    return k.generateKeyPair();
  }

  void encryptDecrypt(String message, AsymmetricKeyPair keyPair) {
//    debugPrint(new RsaKeyHelper().encodePublicKeyToPemPKCS1(keyPair.publicKey));
//    debugPrint(new RsaKeyHelper().encodePrivateKeyToPemPKCS1(keyPair.privateKey));

    AsymmetricKeyParameter<RSAPublicKey> keyParametersPublic =
        new PublicKeyParameter(keyPair.publicKey);
    var cipher = new RSAEngine()..init(true, keyParametersPublic);

    var cipherText = cipher.process(new Uint8List.fromList(message.codeUnits));

    debugPrint('Text: >>' + message + '<<');
    debugPrint('Encrypted: >>' + String.fromCharCodes(cipherText) + '<<');

    AsymmetricKeyParameter<RSAPrivateKey> keyParametersPrivate =
        new PrivateKeyParameter(keyPair.privateKey);

    cipher.init(false, keyParametersPrivate);
    var decrypted = cipher.process(cipherText);
    debugPrint('Decrypted: >>' + String.fromCharCodes(decrypted) + '<<');
  }

  Uint8List encrypt(String message, AsymmetricKeyPair keyPair) {
    message = message.replaceAll("\\P{InBasic_Latin}", "");

    AsymmetricKeyParameter<RSAPublicKey> keyParametersPublic =
        new PublicKeyParameter(keyPair.publicKey);
    var cipher = new RSAEngine()..init(true, keyParametersPublic);
    var cipherText = cipher.process(new Uint8List.fromList(message.codeUnits));
    String x = String.fromCharCodes(cipherText);
    return cipherText;
  }

  String decrypt(Uint8List message, AsymmetricKeyPair keyPair) {
    AsymmetricKeyParameter<RSAPublicKey> keyParametersPublic =
        new PublicKeyParameter(keyPair.publicKey);
    var cipher = new RSAEngine()..init(true, keyParametersPublic);

    AsymmetricKeyParameter<RSAPrivateKey> keyParametersPrivate =
        new PrivateKeyParameter(keyPair.privateKey);
    cipher.init(false, keyParametersPrivate);

    var decrypted = cipher.process(message);
    String x = String.fromCharCodes(decrypted);

    return x;
  }
}
