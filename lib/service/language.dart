import 'package:flutter/material.dart';

class Language  {

  Language ({@required lang}) : _lang = lang;

  String _lang;

  String label (String label) {
    return (label == null? 'NUll'  : label.toUpperCase()) + ' :' + _lang;
  }
}