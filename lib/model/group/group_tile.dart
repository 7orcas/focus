import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/service/util.dart';

class GroupTile extends BaseTile {
  final String name;
  List<GraphTile> graphs;
  final String publicKey;
  final String privateKey;
  DateTime lastGraph = null;
  int unreadComments = 0;

  GroupTile({
    @required id,
    @required created,
    @required this.name,
    @required this.publicKey,
    @required this.privateKey,
    @required this.graphs,
    this.lastGraph,
    this.unreadComments,
  }) : super (id, created);

  GroupTile.entity(GroupEntity e)
      : name = e.name,
        publicKey = null,
        privateKey = null,
        graphs = null,
  super (e.id, e.created);

//  GroupTile copyWith({int id}) {
//    return GroupTile(
//      id: id ?? this.id,
//      name: name ?? this.name,
//      publicKey: publicKey ?? this.publicKey,
//      privateKey: privateKey ?? this.privateKey,
//      graphs: graphs ?? this.graphs,
//    );
//  }

  GraphTile findGraphTile(int id){
    if (!containsGraphs ()) return null;
    for (GraphTile t in graphs){
      if (t.id == id) return t;
    }
    return null;
  }

  bool containsGraphs () {
    Util(StackTrace.current).out('containsGraphs :' + (graphs != null).toString());
    return graphs != null;
  }

  GroupEntity toEntity() {
    return GroupEntity(id, createdMS(), name);
  }

  String lastGraphFormat(){
    if(lastGraph == null) return '';
    return DateFormat('dd MMM yy  hh:mm').format(lastGraph);
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
