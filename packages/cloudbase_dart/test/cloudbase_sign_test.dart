import 'package:test/test.dart';
import 'package:cloudbase_dart/cloudbase_dart.dart';

final data = {
  'x;y;z': 0,
  'c121': 0,
  'c1100': 0,
  'c110': 0,
  'x,y,z': 0,
  'c1.3': 0,
  'c12': 0,
  'a1': 0,
  'c1.2': 0,
  'b2': 0,
  'x-Var-B': 0,
  'x&y&z': 0,
  'c11': 0,
  'b1': 0,
  'c1.1': 0,
  'X-Var-a': 0,
  'a2': 0
};

void main() {
  group('SortedKeyValue', () {
    test('SortedKeyValue.kv', () {
      final kv = SortedKeyValue({
        'ccc': 1, 'aa': 2, 'a11': 3, 'a01': 4, 'bb': 5, 'a22': 6, 'a1': 7
      });

      expect(kv.keys, ['a01', 'a1', 'a11', 'a22', 'aa', 'bb', 'ccc']);
      expect(kv.values, [4, 7, 3, 6, 2, 5, 1]);
      expect(kv.pairs, [
        ['a01', 4],
        ['a1', 7],
        ['a11', 3],
        ['a22', 6],
        ['aa', 2],
        ['bb', 5],
        ['ccc', 1]
      ]);
      expect(kv.get('aa'), 2);
      expect(kv.toString(), 'a01=4&a1=7&a11=3&a22=6&aa=2&bb=5&ccc=1');
      expect(kv.toString(kvSeparator: ':'), 'a01:4&a1:7&a11:3&a22:6&aa:2&bb:5&ccc:1');
      expect(kv.toString(kvSeparator: ':', joinSeparator: ','), 'a01:4,a1:7,a11:3,a22:6,aa:2,bb:5,ccc:1');
    });

    test('SortedKeyValue.kv with selectkeys', () {
      final kv = SortedKeyValue(
        { 'ccc': 1, 'aa': 2, 'a11': 3, 'a01': 4, 'bb': 5, 'a22': 6, 'a1': 7},
        ['a01', 'a1', 'a11', 'a22', 'bb', 'ccc']
      );

      expect(kv.keys, ['a01', 'a1', 'a11', 'a22', 'bb', 'ccc']);
      expect(kv.values, [4, 7, 3, 6, 5, 1]);
    });
  });

  group('Signer', () {
    test('demo', () {
      final signer = Signer(
        secretId: 'AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE',
        secretKey: 'Gu5t9xGARNpq86cd98joQYCN3EXAMPLE',
        service: 'cvm'
      );

      final signInfo = signer.tc3sign(
        method: 'POST',
        url: '/',
        headers: {
          'content-type': 'application/json; charset=utf-8',
          'host': 'cvm.tencentcloudapi.com'
        },
        params: '{"Limit": 1, "Filters": [{"Values": ["\\u672a\\u547d\\u540d"], "Name": "instance-name"}]}',
        timestamp: 1551113065,
        options: {
          'enableHostCheck': false,
          'enableContentTypeCheck': false
        }
      );

      expect(signInfo, {
        'authorization': 'TC3-HMAC-SHA256 Credential=AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE/2019-02-25/cvm/tc3_request, SignedHeaders=content-type;host, Signature=72e494ea809ad7a8c8f7a4507b9bddcbaa8e581f516e8da2f66e2c5a96525168',
        'signedHeaders': ['content-type', 'host'],
        'signedParams': [],
        'signature': '72e494ea809ad7a8c8f7a4507b9bddcbaa8e581f516e8da2f66e2c5a96525168',
        'timestamp': 1551113065,
        'multipart': false
      });
    });

    test('should throw Error when host not match', () {
      var exception;
      try {
        final signInfo = Signer.sign(
          secretId: 'AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE',
          secretKey: 'Gu5t9xGARNpq86cd98joQYCN3EXAMPLE',
          method: 'GET',
          url: 'http://cvm.tencentcloudapi.com/?a=1&b=2&&c=3#t',
          headers: Map<String, dynamic>.from(data)..addAll({
            'content-type': 'application/x-www-form-urlencoded; charset=utf-8',
            'host': 'xxx.tencentcloudapi.com',
          }),
          params: Map<String, dynamic>.from(data),
          timestamp: 1575461831,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, isNot(null));
    });

    test('should throw Error when content-type not exists', () {
      var exception;
      try {
        final signInfo = Signer.sign(
          secretId: 'AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE',
          secretKey: 'Gu5t9xGARNpq86cd98joQYCN3EXAMPLE',
          method: 'GET',
          url: 'http://cvm.tencentcloudapi.com/?a=1&b=2&&c=3#t',
          headers: Map<String, dynamic>.from(data)..addAll({
            // 'content-type': 'application/x-www-form-urlencoded; charset=utf-8',
            'host': 'cvm.tencentcloudapi.com',
          }),
          params: Map<String, dynamic>.from(data),
          timestamp: 1575461831,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, isNot(null));
    });
  });
    
}
