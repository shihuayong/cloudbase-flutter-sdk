## Cloudbase Database for Dart

[![Pub](https://img.shields.io/pub/v/cloudbase_dart)]()

[腾讯云·云开发](https://www.cloudbase.net/)的 Dart 插件。

## 安装

在 dart 项目的 `pubspec.yaml` 文件的 `dependencies` 中添加

```yaml
dependencies:
  cloudbase_dart: ^0.0.5
```

## 简单示例

```dart
import 'package:cloudbase_dart/cloudbase_dart.dart';

void main() async {
  CloudBaseCore core = CloudBaseCore.init({
    'env': 'your-env-id',
    'secretId': 'your-secretId',
    'secretKey': 'your-secretKey'
  });

  // 云函数调用
  CloudBaseFunction function = CloudBaseFunction(core);
  Map<String, dynamic> data = {'a': 1, 'b': 2};
  CloudBaseResponse res = await function.callFunction('sum', data);

  // 数据库查询
  CloudBaseDatabase database = CloudBaseDatabase(core);
  String myOpenID = 'xxx';
  DbQueryRes res2 = await database.collection('user').where({
    '_openid': myOpenID
  }).get();
}
```

`secretId` 和 `secretKey` 是腾讯云 API 固定密钥对，[前往获取](https://console.cloud.tencent.com/cam/capi)。

## 详细文档

[云开发·数据库](https://docs.cloudbase.net/api-reference/flutter/database.html)
