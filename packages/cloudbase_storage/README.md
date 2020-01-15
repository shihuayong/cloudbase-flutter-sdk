# cloudbase_storage

`cloudbase_storage` 是 CloudBase Flutter SDK plugin 之一，提供了在 Flutter 项目中操作 CloudBase 文件存储的能力。

- [安装](#安装)
- [简单示例](#简单示例)
- [API](#api)
  - [上传文件](#上传文件)
    - [参数说明：](#参数说明)
    - [响应结果：void](#响应结果void)
    - [调用示例](#调用示例)
  - [下载文件](#下载文件)
    - [参数说明](#参数说明)
    - [响应：void](#响应void)
    - [调用示例](#调用示例-1)
  - [删除文件](#删除文件)
    - [参数说明](#参数说明-1)
    - [响应结果](#响应结果)
    - [调用示例](#调用示例-2)
  - [获取文件下载链接](#获取文件下载链接)
    - [参数说明](#参数说明-2)
    - [响应结果](#响应结果-1)
    - [调用示例](#调用示例-3)
  - [获取上传文件自定义属性](#获取上传文件自定义属性)
    - [参数说明](#参数说明-3)
    - [响应结果](#响应结果-2)
    - [调用示例](#调用示例-4)

## 安装

在使用 `cloudbase_storage` 时，你也需要安装 `cloudbase_core` 等模块

在 flutter 项目的 `pubspec.yaml` 文件的 `dependencies` 中添加

```yaml
dependencies:
  cloudbase_core: ^0.0.1
  cloudbase_storage: ^0.0.1
```

## 简单示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

void main() async {
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxx'});

  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  CloudBaseStorage storage = CloudBaseStorage(core);

  String fileId = 'cloud://xxxxx/flutter/data.txt';
  String savePath = 'xxxx';
  await storage.downloadFile(fileId, savePath);
}
```

## API

### 上传文件

`Future<void> uploadFile({String cloudPath, String filePath}) async {}`

#### 参数说明：

- cloudPath：云端文件的路径
- filePath：本地文件的路径，需要为能直接访问的路径

#### 响应结果：void

上传文件成功时，`uploadFile` 接口会返回空，失败时则会抛出错误。

#### 调用示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:path_provider/path_provider.dart';

// 获取 flutter Document 路径
// 参考文档：https://flutter.cn/docs/cookbook/persistence/reading-writing-files
_getDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  String path = directory.path;
  return path;
}

void main() async {
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxxx'});
  CloudBaseStorage storage = CloudBaseStorage(core);
  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  String path = await _getDocumentsPath();

  await storage.uploadFile(
      cloudPath: 'flutter/data.txt', filePath: '$path/data.txt');
}
```

### 下载文件

`Future<void> downloadFile({String fileId, String savePath}) async {}`

#### 参数说明

- fileId：需要下载的文件 id
- savePath：保存文件的本地路径

#### 响应：void

#### 调用示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:path_provider/path_provider.dart';

void main async {
  // _getDocumentsPath() 同上
  String docPath = await _getDocumentsPath();

  // 本地存储文件的路径
  String savePath = '$docPath/favicon.png';

  // 初始化实例
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxx'});
  CloudBaseStorage storage = CloudBaseStorage(core);
  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  // 下载文件
  String fileId = 'cloud://xxxx';
  await storage.downloadFile(fileId: fileId, savePath: savePath);
}
```

### 删除云端文件

`Future<CloudBaseStorageRes<List<DeleteMetadata>>> deleteFiles(List<String> fileIdList) async {}`

#### 参数说明

- fileIdList：需要删除的文件 Id 组成的数组

#### 响应结果

```dart
{
  // 请求 Id
  'requestId': 'xx',
  // 被调函数的返回结果
  'data': [
    {
      'fileId': 'xxx',
      'code': 'SUCCESS'
    }
  ]
}
```

#### 调用示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

void main async {
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxx'});
  CloudBaseStorage storage = CloudBaseStorage(core);
  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  String fileId = 'cloud://xxx';
  CloudBaseStorageRes<List<DeleteMetadata>> res = await storage.deleteFiles([fileId]);
  print(res.data[0]); // {'fileId': 'xxx', 'code': 'SUCCESS'}
}
```

### 获取文件下载链接

`Future<CloudBaseStorageRes<List<DownloadMetadata>>> getFileDownloadURL(List<String> fileIdList) async {}`

获取文件下载链接，可以自定义实现下载文件的方法。

#### 参数说明

- fileIdList：需要删除的文件 Id 组成的数组

#### 响应结果

```dart
{
  // 请求 Id
  'requestId': 'xx',
  // 被调函数的返回结果
  'data': [
    {
      'fileId': 'xxx',
      'downloadUrl': 'https://xxx'
    }
  ]
}
```

#### 调用示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

void main() async{
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxxx'});
  CloudBaseStorage storage = CloudBaseStorage(core);

  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  List<String> fileIds = [
    'cloud://xxxx'
  ];
  CloudBaseStorageRes<List<DeleteMetadata>> res res = await storage.getFileDownloadURL(fileIds);
  print(res.data[0]); // {'fileId': 'xxx', 'downloadUrl': 'https://xxx'}
}
```

### 获取上传文件自定义属性

`Future<CloudBaseStorageRes<UploadMetadata>> getUploadMetadata(String cloudPath) async{}`

`getUploadMetadata` 方法可以获取上传文件需要的属性，可用于实现自定义上传文件的逻辑。

#### 参数说明

- cloudPath：云端文件路径

#### 响应结果

```dart
{
  // 请求 Id
  'requestId': 'xx',
  // 被调函数的返回结果
  'data': {
    // 上传文件的 url
    url: 'xxxx',
    // 访问 token
    token: '',
    // 访问授权信息
    authorization: '',
    // 文件 id
    cosFileId: ''
  }
}
```

#### 调用示例

```dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

void main() async {
  CloudBaseCore core = CloudBaseCore.init({'envId': 'xxxx'});
  CloudBaseStorage storage = CloudBaseStorage(core);
  // 微信登录
  CloudBaseAuth auth = CloudBaseWxAuth(core);
  bool isLogin = await auth.isLogin();

  if (!isLogin) {
      await auth.login();
  }

  CloudBaseStorageRes<UploadMetadata>> res = await storage.getUploadMetadata('test/index.txt');
  print(res.data);
}
```
