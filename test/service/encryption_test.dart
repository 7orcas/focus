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
      String y = e.encrypt(x, publicKey);
      String z = e.decrypt(y, privateKey);
      expect(x, z);
    }
  });

  test('Encrypt: keys', () {
    RsaKeyHelper e = RsaKeyHelper();
    var keyPair = e.generateKeyPair();
    print('public: ' + e.encodePublicKeyToPem(keyPair.publicKey));
    print('private: ' + e.encodePrivateKeyToPem(keyPair.privateKey));
  });

  test('Encrypt Me: comments', () {
    RsaKeyHelper e = RsaKeyHelper();
    var keyPair = e.generateKeyPair();
    var publicKey = e.parsePublicKeyFromPem('-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAswyc/76OzJ3I19xmJKPmRnTrWa/msW+tbJ4+flMOV7acGDisu8aWGN302PWxzS/RUSiOCKRXG7RYglVtKu2R2mZknTqDk9q5lJz3sl8f/C5dp6idSfGbq0GiHZbGGAFRuHmWod1uJ7INrBvAh2/OMGTPqTbouxlLZG/qV1A1uorBmw68uLaNt7fYIcjHQZ4LXAHHsM9vquYJzqDz5LIb4k8qG54FRpPGnM2kwCs3yylKnA7MO84A2S/cxUtt1NylsYSo/AG/a7IP1vZWcn9s3vzyxxpLjb3HT/XuobQTRfsK+0j4U4H1aUpmwUmmWo0m2jaSSIeMP/o+96MEkJhVowIDAQAB-----END PUBLIC KEY-----');

    String s = e.encrypt('At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.', publicKey);
    print(">>" + s + "<<");
//    print('public: ' + e.encrypt('Comment 1-2', publicKey));
  });


  test('Decrypt Me: comments', () {
    RsaKeyHelper e = RsaKeyHelper();
    var keyPair = e.generateKeyPair();
    var privateKey = e.parsePrivateKeyFromPem('-----BEGIN PRIVATE KEY-----MIIEwAIBADANBgkqhkiG9w0BAQEFAASCBKowggSmAgEAAoIBAQCzDJz/vo7MncjX3GYko+ZGdOtZr+axb61snj5+Uw5XtpwYOKy7xpYY3fTY9bHNL9FRKI4IpFcbtFiCVW0q7ZHaZmSdOoOT2rmUnPeyXx/8Ll2nqJ1J8ZurQaIdlsYYAVG4eZah3W4nsg2sG8CHb84wZM+pNui7GUtkb+pXUDW6isGbDry4to23t9ghyMdBngtcAcewz2+q5gnOoPPkshviTyobngVGk8aczaTAKzfLKUqcDsw7zgDZL9zFS23U3KWxhKj8Ab9rsg/W9lZyf2ze/PLHGkuNvcdP9e6htBNF+wr7SPhTgfVpSmbBSaZajSbaNpJIh4w/+j73owSQmFWjAgMBAAECggEBAJgkN6P4wE6OJIOH/CNWQe3Mm89x8I0FYE/ThzbATIer26eZQO2uKQyoTc2tuI+p+isEUux0+K/J5wuYm1LG3BDAwO35MqUITnlBiBhBTGR04Y/9bunOK4CyHJcX7uum81HVv3F7PobsfUGps0diccodX3dh+RBCxhVqI65dscn3gfV0+h4cp+ltn09R89J/nT2by7/r7wr7kqebFeKivz4kgjSox2FCdiA6KzzoQuclxoEHnoCl+zJ5wbR7xY+LZVe7MMiKEcpR/h5gbs+OWj719lPrCtQhXQ8yNjfQSwOfGDWEyv3fnClo1zdPzSpMfbd3xIF77zLgwDjmEBUQxAECgYEA2cuHhglOiGMtDqk4GQI1YDMBVEU4YZvR/wjHyjWoj0kSjyVTPgtUFmFHhXDyPmTMgfCKfTO3UBS/4kfhzawnKHsi6Lx1JoyX998ZcCJ/SKhdwpyxXhnZnJUNKXu/vgoqWPOwz5a4LIbOc0298y5ugPLePIyBhRI25FQE/UCBQOMCgYEA0nUjCW+kTmniPNozU/D8ZnmJgo4Wc+8uYoGs5UpN1Y8ITsr+HilLIPCJHz1686pb1qaGHOd79G8FH8CdUuBwZpSjGaJkDxZSlH28QVV+RqX6xg6smgw8f4ijreV0oe5axd4f3IZPfntETjbxXahhGlHAIt33UHq8dm84CxYgdEECgYEAspgYeMw27tZMw2H2E2PhOxJ4O49LjZcGG5kqo+FeaKjmJCXaXd1SRcvdp0oYCxwDK2aBWevHnU52juqc+lf6AFMBLFIlysetcmAq7u4K7BzMTeLJ+z09Wg5LrcHBWOfjE/A5A/E286RTtO+CHODtUqZVoNci+mkWRCO1t6pmkzsCgYEAyPsoPIirRl8DuM1AGzeWMl56nX0HoCuYBmaEMGvnLLztWCGu0CrrHkfXC0hxNGVKUxCwHsZJr8KeCBavp0fCz5O+tmpIV8gfkMMKlvIIJ3u2opG871gkJj7c4OKxoTq44SEhGD4DiGw7bN43XhPAt5u+ew2yct7jP88ynBPDZoECgYEAsnuEAHEG0F/5Uq92/jir3oo0QlCysf3u7fxnvQLeq0GbP8ol01qwWzRywpUWfnSm/wFAtXonvlOHC8mb2DQaRqdVAdJ8mEeGQWvBZPevQiu4gKf5UXYpu5Ya5izqojDLuXpjZ5akopPFz2RJnP/iJQhI7csyXa7SN7z6y1XYtWc=-----END PRIVATE KEY-----');

    String s = e.decrypt('afI9ddRUky5FKgyvAOTq+yJiuIg8HAP5Pjmja80sa9GrH4eA8TSJN3xlKisbVUhgfSPSdnn0T9XeTbZhv+4jHx4XL61skSXdxU9w82WD56HRXEUqya80AQs+YFhEMO1x3b/24hBhrX1Bhq8tQtKLnUhn1SzsiS5syw2PuOPjrhqQ8UmkqHCCb4J74EYoJe3i6fVbgsY5rKw4CeEpVDD+oBjdcHXJzFa6y5i7A7zAShmNPggeCwq0Y9jCZE1leIYGpQnGwPlmwxHaAV8JalSGLT8IDh0E2yt+FdJJZxruz1wnfVpj4B0Nheh9LeSiQF6YvKUHeNGb8LBY3TTQs/6sOw==', privateKey);
    print(">>" + s + "<<");
//    print('public: ' + e.encrypt('Comment 1-2', publicKey));
  });

}
