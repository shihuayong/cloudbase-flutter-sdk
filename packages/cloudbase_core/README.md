# cloudbase_core

[![Pub](https://img.shields.io/pub/v/cloudbase_core)]()

cloudbase_core 是 CloudBase Flutter SDK 的基础依赖，包含了 HTTP 请求，存储等通用方法。使用 `cloudbase_function`、`cloudbase_storage` 等 flutter plugin 时需要先安装 cloudbase_core。

## 安装

在 flutter 项目的 `pubspec.yaml` 文件的 `dependencies` 中添加

```yaml
dependencies:
  cloudbase_core: ^0.0.2
```

## 简单示例

使用 `cloudbase_core` 时，需要先获取实例，`cloudbase_base` 支持通过 `CloudBaseCore()` 或 `CloudBaseCore.init()` 方法获取实例。`CloudBaseCore()` 和 `CloudBaseCore.init()` 方法均为 `factory（工厂）` 构造函数，即使用该方法获取 `CloudBaseCore` 实例对象时，**如果传入了相同的 `env`**，将获取到同一个 `CloudBaseCore` 实例对象，你可以在项目中不同的地方调用构造方法获取相同的实例对象。

使用 `CloudBaseCore()` 构造实例时，需要传入 `CloudBaseConfig` 实例，`CloudBaseConfig` 提供了一些必须的基本配置参数，如环境 Id。

```dart
import 'package:cloudbase_core/cloudbase_core.dart';

// 使用 CloudBaseCore() 获取实例
CloudBaseCore core = CloudBaseCore(CloudBaseConfig(env: 'your-env-id'));
```

你也可以使用 `CloudBaseCore.init()` 从 Map 对象构造 `CloudBaseCore` 实例，此种方法更加简单。

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
// 使用 CloudBaseCore.init() 获取实例
CloudBaseCore core = CloudBaseCore.init({'env': 'your-env-id'});
```
