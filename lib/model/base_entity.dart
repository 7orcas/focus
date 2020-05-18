class BaseEntity {
  final int id;
  DateTime created;

  BaseEntity(this.id, this.created);

  void setCreated() {
    created = DateTime.now();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'created_ms': created.millisecondsSinceEpoch,
      };

  DateTime now() {
    return DateTime.now();
  }

  int fromBool(bool v) {
    return fromBoolean(v);
  }

  static int fromBoolean(bool v) {
    return v != null && v ? 1 : 0;
  }

  bool toBool(int v) {
    return toBoolean(v);
  }

  static bool toBoolean(int v) {
    return v != null && v == 1 ? true : false;
  }
}

class BaseTile {
  final int id;
  final DateTime created;

  BaseTile(this.id, this.created);

  int createdMS() {
    return created == null ? null : created.millisecondsSinceEpoch;
  }

  DateTime dateTime(int ms) {
    return toDateTime(ms);
  }

  static DateTime toDateTime(int ms) {
    return DateTime.fromMicrosecondsSinceEpoch(ms);
  }

  int fromBool(bool v) {
    return fromBoolean(v);
  }

  static int fromBoolean(bool v) {
    return v != null && v ? 1 : 0;
  }

  bool toBool(int v) {
    return toBoolean(v);
  }

  static bool toBoolean(int v) {
    return v != null && v == 1 ? true : false;
  }
}
