import 'package:focus/model/group/graph_entity.dart';
import 'package:focus/model/group/comment_entity.dart';
import 'package:focus/service/encryptRSA.dart';

class GroupConversation {
  final int id;
  final String name;
  final String publicKey;
  final String privateKey;
  final List<GraphEntity> graphs;

  GroupConversation.db(this.id, this.name, this.publicKey, this.privateKey, this.graphs);

  int get count => graphs.length;

  //TODO refactor
  void decrypt (){
    if (privateKey != null && privateKey.length > 0){

      RsaKeyHelper e = RsaKeyHelper();
      var pk = e.parsePrivateKeyFromPem(privateKey);

      for (GraphEntity g in graphs){
        for (CommentEntity c in g.comments){
          c.comment = e.decrypt(c.comment, pk);
        }
      }
    }
  }


}
