import 'package:flutter/material.dart';

/// Lets services and controllers show feedback without a BuildContext.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void showToast(String message) {
  scaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
