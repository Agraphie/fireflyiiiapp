import 'package:flutter/foundation.dart' as foundation;

class Application {
  static bool mockDataEnabled = false;
  static const bool isDebugMode = foundation.kDebugMode;

  static void reset() {
    mockDataEnabled = false;
  }
}
