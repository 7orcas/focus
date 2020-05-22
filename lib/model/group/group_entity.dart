import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/graph/graph_entity.dart';

class GroupEntity extends BaseEntity {
  final String name;
  final String publicKey;
  final String privateKey;
  final List<GraphEntity> graphs;

  GroupEntity(id, created, encoded, this.name, this.publicKey, this.privateKey,
      this.graphs)
      : super(id, created, encoded);

  GroupEntity.add(this.name)
      : publicKey = null,
        privateKey = null,
        graphs = List<GraphEntity>(),
        super(null, null, null);

  GroupEntity copyWith(int id, DateTime created) {
    return GroupEntity(
        id ?? this.id,
        created ?? this.created,
        encoded,
        name,
        publicKey,
        privateKey,
        graphs);
  }

  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      'name': name,
    });
}
