import 'cloudbase_options.dart';

class CloudbaseApp {

  final CloudbaseOptions options;

  CloudbaseApp.configure(CloudbaseOptions options)
  : options = options {
    assert(options != null);
  }
}