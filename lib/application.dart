import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

const Color neutralBackground = Color(0xFFecf0f5);

class Application {
  static bool mockDataEnabled = false;
  static const bool isDebugMode = foundation.kDebugMode;

  static void reset() {
    mockDataEnabled = false;
  }
}
