import 'package:test/test.dart';
import 'package:cloudbase_dart/cloudbase_dart.dart';

void main() {
  test('adds one to input values', () async {
    CloudBaseCore core = CloudBaseCore.init({
      'env': 'test-cloud-5f25f8',
      'secretId': 'AKIDpGg1BBrgrsjYDgoWr384qcGj7KMEMQXU',
      'secretKey': 'vkOrCOPtDNSM4d5MBqKzUo197HI8pSwd'
    });

    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    Map<String, dynamic> data = {'a': 1, 'b': 2};

    CloudBaseResponse res = await cloudbase.callFunction('sum', data);
    assert(res.requestId.isNotEmpty);
    assert(res.data.isNotEmpty);
  });
}
