import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/service/util.dart';

class GroupTile extends BaseTile {
  final String name;
  final String publicKey;
  final String privateKey;
  List<GraphTile> _graphs;
  DateTime _lastGraph = null;
  int _unreadComments = 0;
  String _lastComment = null;

  GroupTile({
    @required id,
    @required created,
    @required this.name,
    @required this.publicKey,
    @required this.privateKey,
    @required graphs,
    lastGraph,
    unreadComments,
    lastComment,
  })  : _graphs = graphs,
        _lastGraph = lastGraph,
        _unreadComments = unreadComments,
        _lastComment = lastComment,
        super(id, created);

  GroupTile.entity(GroupEntity e)
      : name = e.name,
        publicKey = e.publicKey,
        privateKey = e.privateKey,
        _graphs = null,
        super(e.id, e.created){

    if (e.graphs != null){
      _graphs = e.graphs.map((e) => GraphTile.entity(e)).toList();
    }
  }

//  GroupTile copyWith({int id}) {
//    return GroupTile(
//      id: id ?? this.id,
//      name: name ?? this.name,
//      publicKey: publicKey ?? this.publicKey,
//      privateKey: privateKey ?? this.privateKey,
//      graphs: graphs ?? this.graphs,
//    );
//  }

  void addGraph (GraphTile graph){
    if (_graphs == null) _graphs = List<GraphTile>();
    _graphs.add(graph);
  }

  void removeGraph (int id){
    if (_graphs == null) return;
    _graphs.removeWhere((g) => g.id == id);
  }

  List<GraphTile> get graphs => _graphs;
  int get unreadComments => _unreadComments ?? 0;
  String get lastComment => _lastComment ?? 'x';
  void set lastGraph (DateTime d) => _lastGraph = d;
  void set unreadComments (int x) => _unreadComments = x;
  void set lastComment (String c) => _lastComment = c;

  GraphTile findGraphTile(int id) {
    if (!containsGraphs()) return null;
    for (GraphTile t in _graphs) {
      if (t.id == id) return t;
    }
    return null;
  }

  bool containsGraphs() {
    return _graphs != null;
  }

  GroupEntity toEntity() {
    return GroupEntity.add(name);
  }

  String lastGraphFormat() {
    if (_lastGraph == null) return '';
    return DateFormat('dd MMM yy  hh:mm').format(_lastGraph);
  }

  bool get isUserMe => id != null && id == ID_USER_ME;


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
