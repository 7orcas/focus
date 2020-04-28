import 'package:test/test.dart';
import 'package:focus/service/encryption.dart';

const List<String> strings = [
  'abcdef',
  '1234567890',
  'Māori'
];

void main() {

  Encrypt encrypt = Encrypt();

  var keyPair = encrypt.generateKeyPair();


  test('Encrypt Strings', () {
    for (String x in strings) {
      var y = encrypt.encrypt(x, keyPair);
      String z = encrypt.decrypt(y, keyPair);
      print('String: >>' + x + '<<');
      expect(x, z);
    }
  });

}
