import 'package:focus/model/base_entity.dart';

class GroupEntity extends BaseEntity {
  final String name;

  GroupEntity(id, created, this.name) : super(id, created);

  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      'name': name,
    });
}
