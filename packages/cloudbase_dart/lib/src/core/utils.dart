import 'dart:io';

class Utils {
  static bool checkIsInTcbRuntime() {
    return Platform.environment.containsKey('KUBERNETES_SERVICE_HOST');
  }
}
