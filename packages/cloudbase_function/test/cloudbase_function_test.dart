import 'package:flutter_test/flutter_test.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_function/cloudbase_function.dart';

void main() {
  test('调用函数测试', () async {
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    Map<String, dynamic> data = {'a': 1, 'b': 2};

    CloudBaseResponse res = await cloudbase.callFunction('sum', data);
    assert(res.requestId.isNotEmpty);
    assert(res.data.isNotEmpty);
  });

  test('调用函数测试 - Auth fromMap', () async {
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    Map<String, dynamic> data = {'a': 1, 'b': 2};

    var res = await cloudbase.callFunction('sum', data);
    assert(res.requestId.isNotEmpty);
    assert(res.data.isNotEmpty);
  });
}
