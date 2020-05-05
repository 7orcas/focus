import 'package:focus/database/_scheme.dart';
import 'package:focus/database/_base.dart';

// Focus client database setup

const String mock_user = "INSERT INTO " + DB_USER + "(id, number, email, adgj, lang) VALUES ";
const List<String> mock_insertUser = [
  "1, '027 123456789', '123@abc.com', '123asd', 'en'",
];

const String mock_group = "INSERT INTO " + DB_GROUP + "(id, name, public_key, private_key) VALUES ";
const List<String> mock_insertGroup = [
  "1, 'Me', '-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAswyc/76OzJ3I19xmJKPmRnTrWa/msW+tbJ4+flMOV7acGDisu8aWGN302PWxzS/RUSiOCKRXG7RYglVtKu2R2mZknTqDk9q5lJz3sl8f/C5dp6idSfGbq0GiHZbGGAFRuHmWod1uJ7INrBvAh2/OMGTPqTbouxlLZG/qV1A1uorBmw68uLaNt7fYIcjHQZ4LXAHHsM9vquYJzqDz5LIb4k8qG54FRpPGnM2kwCs3yylKnA7MO84A2S/cxUtt1NylsYSo/AG/a7IP1vZWcn9s3vzyxxpLjb3HT/XuobQTRfsK+0j4U4H1aUpmwUmmWo0m2jaSSIeMP/o+96MEkJhVowIDAQAB-----END PUBLIC KEY-----',"
           "'-----BEGIN PRIVATE KEY-----MIIEwAIBADANBgkqhkiG9w0BAQEFAASCBKowggSmAgEAAoIBAQCzDJz/vo7MncjX3GYko+ZGdOtZr+axb61snj5+Uw5XtpwYOKy7xpYY3fTY9bHNL9FRKI4IpFcbtFiCVW0q7ZHaZmSdOoOT2rmUnPeyXx/8Ll2nqJ1J8ZurQaIdlsYYAVG4eZah3W4nsg2sG8CHb84wZM+pNui7GUtkb+pXUDW6isGbDry4to23t9ghyMdBngtcAcewz2+q5gnOoPPkshviTyobngVGk8aczaTAKzfLKUqcDsw7zgDZL9zFS23U3KWxhKj8Ab9rsg/W9lZyf2ze/PLHGkuNvcdP9e6htBNF+wr7SPhTgfVpSmbBSaZajSbaNpJIh4w/+j73owSQmFWjAgMBAAECggEBAJgkN6P4wE6OJIOH/CNWQe3Mm89x8I0FYE/ThzbATIer26eZQO2uKQyoTc2tuI+p+isEUux0+K/J5wuYm1LG3BDAwO35MqUITnlBiBhBTGR04Y/9bunOK4CyHJcX7uum81HVv3F7PobsfUGps0diccodX3dh+RBCxhVqI65dscn3gfV0+h4cp+ltn09R89J/nT2by7/r7wr7kqebFeKivz4kgjSox2FCdiA6KzzoQuclxoEHnoCl+zJ5wbR7xY+LZVe7MMiKEcpR/h5gbs+OWj719lPrCtQhXQ8yNjfQSwOfGDWEyv3fnClo1zdPzSpMfbd3xIF77zLgwDjmEBUQxAECgYEA2cuHhglOiGMtDqk4GQI1YDMBVEU4YZvR/wjHyjWoj0kSjyVTPgtUFmFHhXDyPmTMgfCKfTO3UBS/4kfhzawnKHsi6Lx1JoyX998ZcCJ/SKhdwpyxXhnZnJUNKXu/vgoqWPOwz5a4LIbOc0298y5ugPLePIyBhRI25FQE/UCBQOMCgYEA0nUjCW+kTmniPNozU/D8ZnmJgo4Wc+8uYoGs5UpN1Y8ITsr+HilLIPCJHz1686pb1qaGHOd79G8FH8CdUuBwZpSjGaJkDxZSlH28QVV+RqX6xg6smgw8f4ijreV0oe5axd4f3IZPfntETjbxXahhGlHAIt33UHq8dm84CxYgdEECgYEAspgYeMw27tZMw2H2E2PhOxJ4O49LjZcGG5kqo+FeaKjmJCXaXd1SRcvdp0oYCxwDK2aBWevHnU52juqc+lf6AFMBLFIlysetcmAq7u4K7BzMTeLJ+z09Wg5LrcHBWOfjE/A5A/E286RTtO+CHODtUqZVoNci+mkWRCO1t6pmkzsCgYEAyPsoPIirRl8DuM1AGzeWMl56nX0HoCuYBmaEMGvnLLztWCGu0CrrHkfXC0hxNGVKUxCwHsZJr8KeCBavp0fCz5O+tmpIV8gfkMMKlvIIJ3u2opG871gkJj7c4OKxoTq44SEhGD4DiGw7bN43XhPAt5u+ew2yct7jP88ynBPDZoECgYEAsnuEAHEG0F/5Uq92/jir3oo0QlCysf3u7fxnvQLeq0GbP8ol01qwWzRywpUWfnSm/wFAtXonvlOHC8mb2DQaRqdVAdJ8mEeGQWvBZPevQiu4gKf5UXYpu5Ya5izqojDLuXpjZ5akopPFz2RJnP/iJQhI7csyXa7SN7z6y1XYtWc=-----END PRIVATE KEY-----'",
  "2, 'Group 1','',''",
  "3, 'Group 2','',''",
  "4, 'Group 3','',''",
];

const String mock_userGroup = "INSERT INTO " + DBJ_USER_GROUP + "(id, " + DBK_USER + ", " + DBK_GROUP + ", admin) VALUES ";
const List<String> mock_insertUserGroup = [
  "1, 1, 1, 1",
  "2, 1, 2, 0",
];

const String mock_graph = "INSERT INTO " + DB_GRAPH + "(id, " + DBK_GROUP + ", graph) VALUES ";
const List<String> mock_insertGraph = [
  "1, 1, 'Graph 1'",
  "2, 1, 'Graph 2'",
  "3, 1, 'Graph 3'",
  "4, 1, 'Graph 4'",
//  "5, 1, 'Graph 5'",
//  "6, 1, 'Graph 6'",
//  "7, 1, 'Graph 7'",
//  "8, 1, 'Graph 8'",
//  "9, 1, 'Graph 9'",
//  "10, 1, 'Graph 10'",
//  "11, 1, 'Graph 11'",
//  "12, 1, 'Graph 12'",
//  "13, 1, 'Graph 13'",
//  "14, 1, 'Graph 14'",
//  "15, 1, 'Graph 15'",
//  "16, 1, 'Graph 16'",
//  "17, 1, 'Graph 17'",
//  "18, 1, 'Graph 18'",
//  "19, 1, 'Graph 19'",
//  "20, 1, 'Graph 20'",
  "50, 2, 'Graph 1'",
];

const String mock_comment = "INSERT INTO " + DB_COMMENT + "(id, " + DBK_GROUP + ", " + DBK_GRAPH + ", " + DBK_USER + ", comment) VALUES ";
const List<String> mock_insertComment = [
//  "1, 1, 1, 1, 'rakIUh/CA3erMdWc0AQ8vrY7VjFUwlAeER/xn+ORfsnUhlZTqGNxRvpqr2EqPQqxy0QGOopUFRCaBWd4vi2HaefjSo1A/2il+52utaqAaYTeqf9mbSYd69pyvDCNuRgZC6sPbyEBsyTNegRhAFdxXSDcszd9vRKXmBW1OR8gm1bQQLtq7vcG9R/hWPZ+UN/zHgDueKWHZZQDwtUjRhuoTi5moMLOifY+GZAXQV2uivpmNw3sVSGeHodVEJspbQCYveQ1XT2FHi5k7BhDF5BaVJ3AH0J3VjbxestJV9vtkNpSyBu67iP4bTDvZkzrRNzDmnABFXRURLqDdG6Pan7pYw=='",
//  "2, 1, 1, 1, 'rakIUh/CA3erMdWc0AQ8vrY7VjFUwlAeER/xn+ORfsnUhlZTqGNxRvpqr2EqPQqxy0QGOopUFRCaBWd4vi2HaefjSo1A/2il+52utaqAaYTeqf9mbSYd69pyvDCNuRgZC6sPbyEBsyTNegRhAFdxXSDcszd9vRKXmBW1OR8gm1bQQLtq7vcG9R/hWPZ+UN/zHgDueKWHZZQDwtUjRhuoTi5moMLOifY+GZAXQV2uivpmNw3sVSGeHodVEJspbQCYveQ1XT2FHi5k7BhDF5BaVJ3AH0J3VjbxestJV9vtkNpSyBu67iP4bTDvZkzrRNzDmnABFXRURLqDdG6Pan7pYw=='",
//  "3, 1, 2, 1, 'afI9ddRUky5FKgyvAOTq+yJiuIg8HAP5Pjmja80sa9GrH4eA8TSJN3xlKisbVUhgfSPSdnn0T9XeTbZhv+4jHx4XL61skSXdxU9w82WD56HRXEUqya80AQs+YFhEMO1x3b/24hBhrX1Bhq8tQtKLnUhn1SzsiS5syw2PuOPjrhqQ8UmkqHCCb4J74EYoJe3i6fVbgsY5rKw4CeEpVDD+oBjdcHXJzFa6y5i7A7zAShmNPggeCwq0Y9jCZE1leIYGpQnGwPlmwxHaAV8JalSGLT8IDh0E2yt+FdJJZxruz1wnfVpj4B0Nheh9LeSiQF6YvKUHeNGb8LBY3TTQs/6sOw=='",
  "1, 1, 1, 1, 'grpah 1 comment 1'",
  "2, 1, 1, 1, 'grpah 1 comment 2'",
  "3, 1, 1, 1, 'grpah 1 comment 3'",
  "4, 1, 1, 1, 'grpah 1 comment 4'",
  "5, 1, 1, 1, 'grpah 1 comment 5'",
  "6, 1, 1, 1, 'grpah 1 comment 6'",
  "7, 1, 1, 1, 'grpah 1 comment 7'",
  "8, 1, 1, 1, 'grpah 1 comment 8'",
  "9, 1, 1, 1, 'grpah 1 comment 9'",

  "11, 1, 2, 1, 'graph 2 comment 1'",
  "12, 1, 2, 1, 'graph 2 comment 2'",
  "13, 1, 2, 1, 'graph 2 comment 3'",
  "14, 1, 2, 1, 'graph 2 comment 4'",
  "15, 1, 2, 1, 'graph 2 comment 5'",
  "16, 1, 2, 1, 'graph 2 comment 6'",
  "17, 1, 2, 1, 'graph 2 comment 7'",
  "18, 1, 2, 1, 'graph 2 comment 8'",
  "19, 1, 2, 1, 'graph 2 comment 9'",

  "21, 1, 3, 1, 'graph 3 comment 1'",
  "22, 1, 3, 1, 'graph 3 comment 2'",
  "23, 1, 3, 1, 'graph 3 comment 3'",
  "24, 1, 3, 1, 'graph 3 comment 4'",
  "25, 1, 3, 1, 'graph 3 comment 5'",
  "26, 1, 3, 1, 'graph 3 comment 6'",
  "27, 1, 3, 1, 'graph 3 comment 7'",
  "28, 1, 3, 1, 'graph 3 comment 8'",
  "29, 1, 3, 1, 'graph 3 comment 9'",

//  "50, 1, 2, 1, 'comment 3'",
];


const mock_instructions = [
  mock_user, mock_insertUser,
  mock_group, mock_insertGroup,
  mock_userGroup, mock_insertUserGroup,
  mock_graph, mock_insertGraph,
  mock_comment, mock_insertComment,
];


class DatabaseMockData extends FocusDB {

  static List<String> data () {
    List<String> d = [];

    for (int x = 0; x < mock_instructions.length; x += 2){
      String sql = mock_instructions[x];
      List<String> data = mock_instructions[x+1];

      for (int i = 0; i< data.length; i++){
        d.add(sql + "(" + data[i] + ")");
      }
    }

    return d;
  }

  Future<bool> reload () async {
    List<String> t = [
      'DELETE FROM ' + DB_COMMENT,
      'DELETE FROM ' + DB_GRAPH,
      'DELETE FROM ' + DBJ_USER_GROUP,
      'DELETE FROM ' + DB_GROUP,
      'DELETE FROM ' + DB_USER,
    ];
    List<String> d = data();
    t.addAll(d);

    await connectDatabase();
    for (String s in t){
      await database.execute(s);
    }
    return Future.value(true);
  }

}