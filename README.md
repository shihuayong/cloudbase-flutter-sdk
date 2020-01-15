# CloudBase Flutter SDK

CloudBase Flutter SDK 是腾讯云云开发（Tencent Cloud Base）多端 SDK 中的一员，主要支持 Flutter 框架下使用云开发能力。CloudBase 提供 Serverless 云端一体化服务，使用 CloudBase，可以快速构建小程序、移动App、网页等应用。

## Flutter 插件

CloudBase Flutter SDK 提供一系列插件，可以根据场景按需加载。

| Plugin                             | Version                        | 文档                               | 描述
| ---------------------------------- | ------------------------------ | ---------------------------------- | ----------------------
| [cloudbase_core][core_pub]         | ![pub package][core_badge]     | [CloudBase Core][core_doc]         | 核心库，初始化环境等
| [cloudbase_auth][auth_pub]         | ![pub package][auth_badge]     | [CloudBase Auth][auth_doc]         | 鉴权库，包括微信登录等能力
| [cloudbase_function][function_pub] | ![pub package][function_badge] | [CloudBase Function][function_doc] | 支持云函数能力
| [cloudbase_storage][storage_pub]   | ![pub package][storage_badge]  | [CloudBase Storage][storage_doc]   | 支持对象存储能力

[core_pub]: https://pub.dartlang.org/packages/cloudbase_core
[auth_pub]: https://pub.dartlang.org/packages/cloudbase_auth
[function_pub]: https://pub.dartlang.org/packages/cloudbase_function
[storage_pub]: https://pub.dartlang.org/packages/cloudbase_storage
[core_badge]: https://img.shields.io/pub/v/cloudbase_core
[auth_badge]: https://img.shields.io/pub/v/cloudbase_auth
[function_badge]: https://img.shields.io/pub/v/cloudbase_function
[storage_badge]: https://img.shields.io/pub/v/cloudbase_storage
[core_doc]: ./packages/cloudbase_core/README.md
[auth_doc]: ./packages/cloudbase_auth/README.md
[function_doc]: ./packages/cloudbase_function/README.md
[storage_doc]: ./packages/cloudbase_storage/README.md

## 快速开始

### 1. 配置云开发资源

在 [腾讯云云开发控制台](https://console.cloud.tencent.com/tcb) 创建环境（已有环境可跳过）。

<img src="./img/1.png">

新建云函数 `sum`。

<img src="./img/2.png">

在 `sum` 云函数中添加代码。

```js
"use strict";
exports.main = (event, context, callback) => {
  callback(null, event.a + event.b);
};
```

### 2. 创建 Flutter 项目

```shell
$ flutter create cloudbase_demo
$ cd cloudbase_demo
```

### 3. 添加 CloudBase 插件依赖

在项目的 `pubspec.yaml` 文件中添加 `dependencies` 。

```yaml
dependencies:
  cloudbase_core: ^0.0.1
  cloudbase_auth: ^0.0.1
  cloudbase_functions: ^0.0.1
```

从 `pub` 安装依赖。

```shell
$ flutter pub get
```

### 4. 微信登录额外配置

根据 [CloudBaseAuth 详细教程-微信登录](./packages/cloudbase_auth/doc/wxauth.md) 作好微信登录前的必要配置。( Android 配置相对简单，建议先在 Android 端体验)

### 5. 调用云函数

在项目的 `lib/main.dart` 文件中进行微信登录，并调用运用 `sum` 云函数。

```dart
import 'package:cloudbase_auth/cloudbase_core.dart';
import 'package:cloudbase_core/cloudbase_autj.dart';
import 'package:cloudbase_function/cloudbase_function.dart';

// 初始化 CloudBase
CloudBaseCore core = CloudBaseCore.init({
    // 填写你的云开发 envId 和微信开放平台 Appid
    'envId': 'xxx',
    'wxAppId': 'xxxx'
});

// 微信登录
CloudBaseAuth auth = CloudBaseWxAuth(core);
bool isLogin = await auth.isLogin();

if (!isLogin) {
    await auth.login().catchError((e) {
      // 处理微信登录错误
      print(e);
    })
}

// 调用云函数
CloudBaseFunction func = CloudBaseFunction(core);
Map<String, dynamic> data = {'a': 1, 'b': 2};
CloudBaseResponse res = await func.callFunction('sum', data);
// 打印云函数结果
print(res);
```
