import 'dart:convert';
import 'package:intl/intl.dart';

class BaseEntity {
  final int id;
  DateTime created;
  String encoded;
  Map <String, dynamic>_parameters;

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

  T getEncoded<T>(String key, var defaultValue) {
    if (encoded == null || encoded.isEmpty) return defaultValue;
    if (_parameters == null){
      _parameters = Map();
      for (String x in encoded.split(',')){
        List a = x.split(':');
        String k = a[0];
        var v;
        switch (defaultValue.runtimeType){
          case int: v = int.parse(a[1]); break;
          case String: v = a[1];
        }
        _parameters[k] = v;
      }
    }
    if (_parameters.containsKey(key)) return _parameters[key];
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
    return DateFormat('dd MMM yy  hh:mm').format(created);
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
