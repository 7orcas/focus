
class GroupEntity {
  final int id;
  final String name;

  GroupEntity(this.id, this.name);

  Map<String, dynamic> toMap() => {
    'id' : id,
    'name' : name,
  };
}