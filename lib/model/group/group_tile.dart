import 'package:flutter/foundation.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/service/util.dart';

class GroupTile {
  final int id;
  final String name;
  List<GraphTile> graphs;
  final String publicKey;
  final String privateKey;

  GroupTile({
    @required this.id,
    @required this.name,
    @required this.publicKey,
    @required this.privateKey,
    @required this.graphs,
  });

  GroupTile.entity(GroupEntity e)
      : id = e.id,
        name = e.name,
        publicKey = null,
        privateKey = null,
        graphs = null;

  GroupTile copyWith({int id}) {
    return GroupTile(
      id: id ?? this.id,
      name: name ?? this.name,
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
      graphs: graphs ?? this.graphs,
    );
  }

  bool containsGraphs () {
    Util(StackTrace.current).out('containsGraphs :' + (graphs != null).toString());
    return graphs != null;
  }

  GroupEntity toEntity() {
    return GroupEntity(id, name);
  }


//  TODO refactor
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
