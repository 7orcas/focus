import 'package:focus/service/encryptRSA.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/graph/graph_tile.dart';

//ToDo Delete

class GroupConversation {
  final int id;
  final String name;
  final String publicKey;
  final String privateKey;
  final List<GraphTile> graphs;

  GroupConversation.db(
      this.id, this.name, this.publicKey, this.privateKey, this.graphs);

  int get count => graphs.length;

  GroupTile toGroupTile() {
    return GroupTile(
        id: this.id,
        name: this.name,
        graphs: this.graphs);
  }

  //TODO refactor
//  void decrypt() {
//    if (privateKey != null && privateKey.length > 0) {
//      RsaKeyHelper e = RsaKeyHelper();
//      var pk = e.parsePrivateKeyFromPem(privateKey);
//
//      for (GraphEntity g in graphs) {
//        for (CommentEntity c in g.comments) {
//          c.comment = e.decrypt(c.comment, pk);
//        }
//      }
//    }
//  }

}
