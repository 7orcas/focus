
class BaseEntity {

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