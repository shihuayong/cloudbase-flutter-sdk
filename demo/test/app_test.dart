import 'package:flutter_test/flutter_test.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:demo/constance.dart';
import 'package:demo/main.dart' as app;

void main() async {
  group('CloudBase Flutter SDK 测试', () {
    CloudBaseFunction cloudbaseFunc;

    setUpAll(() async {
      app.main();
      // 启动
      CloudBaseCore core = CloudBaseCore.init(baseConfig);
      CloudBaseWxAuth(core);
      cloudbaseFunc = CloudBaseFunction(core);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
    });

    test('callFunction Test', () async {
      Map<String, dynamic> data = {'a': 1, 'b': 2};

      CloudBaseResponse res = await cloudbaseFunc.callFunction('sum', data);
      print(res);
      assert(res.requestId.isNotEmpty);
      assert(res.data.isNotEmpty);
      assert(res.data['sum'] == 3);
    });
//
//    test('callFunction 字符串参数', () async {
//      String data = 'test';
//
//      CloudBaseResponse res = await cloudbaseFunc.callFunction('result', data);
//      assert(res.requestId.isNotEmpty);
//      assert(res.data.isNotEmpty);
//    });
//
//    test('callFunction 无参数', () async {
//      CloudBaseResponse res = await cloudbaseFunc.callFunction('result');
//      assert(res.requestId.isNotEmpty);
//      assert(res.data.isNotEmpty);
//    });
  });
}
