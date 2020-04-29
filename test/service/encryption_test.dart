import 'package:test/test.dart';
import 'package:focus/service/encryptRSA.dart';
import 'dart:convert';

const List<String> strings = [
  'abcdef',
  '1234567890',
  '''
My name is John Stewart
 xx
z

 ''',
  '',
  null,
  'āēīōū',
  'Māori',
  'ātaahua',
  'tō',
  'ē',
  'हैलो',
  '你好',
];

void main() {


  test('Encrypt: Strings', () {
    RsaKeyHelper e = RsaKeyHelper();
    var keyPair = e.generateKeyPair();

    String public = e.encodePublicKeyToPem(keyPair.publicKey);
    String private = e.encodePrivateKeyToPem(keyPair.privateKey);

    var publicKey = e.parsePublicKeyFromPem(public);
    var privateKey = e.parsePrivateKeyFromPem(private);
    
    for (String x in strings) {
      print('Testing: \'' + (x ?? 'null') + '\'');
      var y = e.encrypt(x, publicKey);
      String z = e.decrypt(y, privateKey);
      expect(x, z);
    }

  });


}
