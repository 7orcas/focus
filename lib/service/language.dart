import 'package:flutter/material.dart';

class Language  {

  String label (String label) {
    return label == null? 'NUll' : label.toUpperCase();
  }
}