import 'package:flutter/material.dart';

extension DialogExtensions on BuildContext {
  void hideKeyboard() {
    FocusScope.of(this).requestFocus(FocusNode());
  }
}