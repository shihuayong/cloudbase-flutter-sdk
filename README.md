CloudBase Flutter SDK 是腾讯云云开发（Tencent Cloud Base）多端 SDK 中的一员，主要支持 Flutter 框架下使用云开发能力。CloudBase 提供 Serverless 云端一体化服务，使用 CloudBase，可以快速构建小程序、移动App、网页等应用。

## Flutter 插件

CloudBase Flutter SDK 提供一系列插件，可以根据场景按需加载。

| Plugin                             | Version                        | 文档                               | 描述
| ---------------------------------- | ------------------------------ | ---------------------------------- | ----------------------
| [cloudbase_core][core_pub]         | ![pub package][core_badge]     | [CloudBase Core][core_doc]         | 核心库，初始化环境等
| [cloudbase_auth][auth_pub]         | ![pub package][auth_badge]     | [CloudBase Auth][auth_doc]         | 鉴权库，支持微信登录、自定义登录、匿名登录等
| [cloudbase_function][function_pub] | ![pub package][function_badge] | [CloudBase Function][function_doc] | 支持云函数能力
| [cloudbase_database][database_pub]   | ![pub package][database_badge]  | [CloudBase Database][database_doc]   | 支持文档型数据库能力
| [cloudbase_storage][storage_pub]   | ![pub package][storage_badge]  | [CloudBase Storage][storage_doc]   | 支持对象存储能力

[core_pub]: https://pub.dartlang.org/packages/cloudbase_core
[auth_pub]: https://pub.dartlang.org/packages/cloudbase_auth
[function_pub]: https://pub.dartlang.org/packages/cloudbase_function
[database_pub]: https://pub.dartlang.org/packages/cloudbase_database
[storage_pub]: https://pub.dartlang.org/packages/cloudbase_storage
[core_badge]: https://img.shields.io/pub/v/cloudbase_core
[auth_badge]: https://img.shields.io/pub/v/cloudbase_auth
[function_badge]: https://img.shields.io/pub/v/cloudbase_function
[database_badge]: https://img.shields.io/pub/v/cloudbase_database
[storage_badge]: https://img.shields.io/pub/v/cloudbase_storage
[core_doc]: ./packages/cloudbase_core/README.md
[auth_doc]: ./packages/cloudbase_auth/README.md
[function_doc]: ./packages/cloudbase_function/README.md
[database_doc]: ./packages/cloudbase_database/README.md
[storage_doc]: ./packages/cloudbase_storage/README.md

## 快速开始

### 1. 配置云开发资源

在 [腾讯云云开发控制台](https://console.cloud.tencent.com/tcb) 创建环境（已有环境可跳过）。

<img src="https://tencentcloudbase.github.io/flutter/env/1.png">

在[用户管理页面](https://console.cloud.tencent.com/tcb/user)中，点击“登录设置”，然后**启用匿名登录**：

<img src="https://tencentcloudbase.github.io/flutter/auth/1.png">

新建云函数 `sum`。

<img src="https://tencentcloudbase.github.io/flutter/env/2.png">

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
  cloudbase_core: ^0.0.2
  cloudbase_auth: ^0.0.2
  cloudbase_functions: ^0.0.1
```

从 `pub` 安装依赖。

```shell
$ flutter pub get
```

### 4. 调用云函数

在项目的 `lib/main.dart` 文件中进行匿名登录，并调用运用 `sum` 云函数。

```dart
import 'package:cloudbase_auth/cloudbase_core.dart';
import 'package:cloudbase_core/cloudbase_autj.dart';
import 'package:cloudbase_function/cloudbase_function.dart';

// 初始化 CloudBase
CloudBaseCore core = CloudBaseCore.init({
    // 填写你的云开发 env
    'env': 'your-env-id'
});

// 获取登录状态
CloudBaseAuthState authState = await auth.getAuthState();

// 唤起匿名登录
if (authState == null) {
    await auth.signInAnonymously().catchError((err) {
        // 处理匿名登录错误
        print(e);
    });
}

// 调用云函数
CloudBaseFunction func = CloudBaseFunction(core);
Map<String, dynamic> data = {'a': 1, 'b': 2};
CloudBaseResponse res = await func.callFunction('sum', data);
// 打印云函数结果
print(res);
```
