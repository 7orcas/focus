import 'dart:convert';
import 'package:intl/intl.dart';

class BaseEntity {
  final int id;
  DateTime created;
  String encoded;
  Map<String, String> _parameters;

  BaseEntity(this.id, this.created, this.encoded);

  void setCreated() {
    created = DateTime.now();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'created_ms': created.millisecondsSinceEpoch,
        'encoded': encoded,
      };

  DateTime now() {
    return DateTime.now();
  }

  String addEncoded(String key, var parameter) {
    encoded = addEncoding(key, parameter, encoded);
    return encoded;
  }

  static String addEncoding(String key, var parameter, String encoded) {
    encoded = encoded ?? '';
    if (encoded.length > 0) encoded += ',';
    encoded += key + ':' + parameter.toString();
    return encoded;
  }

  T getEncoded<T>(String key, T defaultValue) {
    if (encoded == null || encoded.isEmpty) return defaultValue;
    if (_parameters == null) {
      _parameters = Map<String, String>();
      for (String x in encoded.split(',')) {
        List a = x.split(':');
        _parameters[a[0]] = a[1];
      }
    }

    if (!_parameters.containsKey(key)) return defaultValue;

    try {
      var v;
      switch (T) {
        case int:
          v = int.parse(_parameters[key]);
          break;
        case bool:
          v = _parameters[key] == true.toString();
          break;
        case String:
          v = _parameters[key];
      }
      return v;
    } on Exception catch (e){}

    return defaultValue;
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

  String createdFormat() {
    if (created == null) return '';
    return DateFormat.yMMMMd('en_US').add_jm().format(created);
  }

  String addEncoded(String encoded, String key, var parameter) {
    encoded = BaseEntity.addEncoding(key, parameter, encoded);
    return encoded;
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
