import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

_getDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  String path = directory.path;
  return path;
}

void main() async {
  test('uploadFile', () async {
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseStorage storage = CloudBaseStorage(core);

    String path = await _getDocumentsPath();

    await storage.uploadFile(
        cloudPath: 'flutter/data.txt', filePath: '$path/data.txt');
  });

  test('downloadFile', () async {
    String docPath = await _getDocumentsPath();
    String savePath = '$docPath/favicon.png';

    // 初始化实例
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseStorage storage = CloudBaseStorage(core);

    String fileId =
        'cloud://dev-97eb6c.6465-dev-97eb6c-1252710547/flutter/favicon.png';

    await storage.downloadFile(fileId: fileId, savePath: savePath);
  });

  test('getUploadMetadata', () async {
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseStorage storage = CloudBaseStorage(core);
    CloudBaseStorageRes<UploadMetadata> res =
        await storage.getUploadMetadata('test/index.txt');
    print(res);
  });

  test('getFileDownloadURL', () async {
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseStorage storage = CloudBaseStorage(core);
    List<String> fileIds = [
      'cloud://dev-97eb6c.6465-dev-97eb6c-1252710547/flutter/data.txt'
    ];
    var res = await storage.getFileDownloadURL(fileIds);
    print(res);
  });

  test('deleteFiles', () async {
    CloudBaseCore core = CloudBaseCore.init({'envId': 'dev-97eb6c'});
    CloudBaseStorage storage = CloudBaseStorage(core);
    String fileId =
        'cloud://dev-97eb6c.6465-dev-97eb6c-1252710547/firebase-tools-instant-win.exe';
    var res = await storage.deleteFiles([fileId]);
    print(res);
    print(res.data[0]);
  });
}
