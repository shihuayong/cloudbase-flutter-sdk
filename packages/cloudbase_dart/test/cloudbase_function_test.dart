import 'package:test/test.dart';
import 'package:cloudbase_dart/cloudbase_dart.dart';

import 'config.dart' as testConfig;

void main() {
  test('adds one to input values', () async {
    CloudBaseCore core = CloudBaseCore.init(testConfig.envInfo);

    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    Map<String, dynamic> data = {'a': 1, 'b': 2};

    CloudBaseResponse res = await cloudbase.callFunction('sum', data);
    assert(res.requestId.isNotEmpty);
    assert(res.data.isNotEmpty);
  });
}
