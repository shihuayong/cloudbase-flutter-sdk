# cloudbase_function

`cloudbase_function` 为 CloudBase Flutter SDK plugin 之一，提供了在 Flutter 项目中调用 CloudBase 云函数的能力。

## 安装

在使用 `cloudbase_function` 时，你也需要安装 `cloudbase_core` 等模块

在 flutter 项目的 `pubspec.yaml` 文件的 `dependencies` 中添加

```yaml
dependencies:
  cloudbase_core: ^0.0.1
  cloudbase_function: ^0.0.1
```

## 简单示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_function/cloudbase_function.dart';

void main() async {
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxxx'});
  CloudBaseFunction cloudbase = CloudBaseFunction(core);

  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  // 请求参数
  Map<String, dynamic> data = {'a': 1, 'b': 2};
  CloudBaseResponse res = await cloudbase.callFunction('sum', data);
  print(res.data) // { sum: 3 }
}
```

## API

### 调用云函数

`Future<CloudBaseResponse> callFunction(String name, Map<String, dynamic> params) async {}`

#### 参数说明

- name：函数名称
- params：被调函数的入参

#### 响应结果

```dart
{
  // 请求 Id
  'requestId': 'xx',
  // 被调函数的返回结果
  'data': ''
}
```

#### 调用示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_function/cloudbase_function.dart';

void main() async {
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxx'});

  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  CloudBaseFunction cloudbase = CloudBaseFunction(core);

  // 请求参数
  Map<String, dynamic> data = {'a': 1, 'b': 2};
  CloudBaseResponse res = await cloudbase.callFunction('sum', data);
  print(res.data) // { sum: 3 }
}
```
