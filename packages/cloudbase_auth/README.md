# cloudbase_auth

[![Pub](https://img.shields.io/pub/v/cloudbase_auth)]()

`cloudbase_auth` 为 CloudBase Flutter SDK plugin 之一，提供了在 Flutter 项目中调用 CloudBase 登录的能力，其他CloudBase能力需要登录后才能使用。

暂时只支持微信登录，后续将支持自定义登录和匿名登录。

## 安装

在使用 `cloudbase_auth` 时，你也需要安装 `cloudbase_core` 等模块

在 flutter 项目的 `pubspec.yaml` 文件的 `dependencies` 中添加

```yaml
dependencies:
  cloudbase_core: ^0.0.1
  cloudbase_auth: ^0.0.1
```

## 简单示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';

CloudBaseCore core = CloudBaseCore.init({
    'envId': 'xxx',
    'wxAppId': 'xxxx'
});
// CloudBase微信登录
CloudBaseAuth auth = CloudBaseWxAuth(core);
bool isLogin = await auth.isLogin();
if (!isLogin) {
    await auth.login();
}

```

## API

### 获取登录状态

`Future<bool> isLogin() async {}`

### 开始登录

`Future<String> login() async {}`

## 详细教程

* [微信登录](./doc/wxauth.md)