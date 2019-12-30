import 'dart:async';

import 'package:cloudbase_core/cloudbase_core.dart';

abstract class CloudBaseAuth implements ICloudBaseAuth {

  Future<bool> login();

  Future<bool> isLogin();

}