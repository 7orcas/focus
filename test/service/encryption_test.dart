import 'package:test/test.dart';
import 'package:focus/service/encryptRSA.dart';
import 'dart:convert';

List<String> strings = [
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
  ASCII_START,
  ASCII_END,
  ASCII_END + 'ō',
  ASCII_START + ASCII_END,
  ASCII_START + '12344567' + ASCII_END,
//  Doesn't work
//  ASCII_START + 'ō',
//  ASCII_START + '123' + ASCII_END,
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
