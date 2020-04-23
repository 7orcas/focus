
class GroupEntity {
  final int id;
  final String name;
  final int admin;

  GroupEntity(this.id, this.name, this.admin);

  Map<String, dynamic> toMap() => {
    'id' : id,
    'name' : name,
    'admin' : admin,
  };
}