import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:demo/constance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  String _text = '测试前请先登录';
  CloudBaseCore _core;

  _TestPage() {
    _core = CloudBaseCore.init(baseConfig);
  }

  _getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    return path;
  }

  _writeFile() async {
    String path = await _getDocumentsPath();

    File file = File('$path/data.txt');

    await file.writeAsString('test data');

    print('写入本地测试文件完成');
  }

  _testFile() async {
    await _writeFile();
    String fileId = '';

    test('uploadFile', () async {
      // 获取路径
      String docPath = await _getDocumentsPath();
      String filePath = '$docPath/data.txt';
      // 初始化实例
      CloudBaseStorage storage = CloudBaseStorage(_core);
      CloudBaseStorageRes<UploadRes> res = await storage.uploadFile(
          cloudPath: 'flutter/data.txt', filePath: filePath, onProcess: (count, total) {
            print(count);
            print(total);
          });
      print('上传文件完成');
      assert(res.data.fileId.isNotEmpty);
    });

    test('downloadFile', () async {
      String docPath = await _getDocumentsPath();
      String savePath = '$docPath/data_download.txt';
      // 初始化实例
      CloudBaseStorage storage = CloudBaseStorage(_core);
      String fileId = 'cloud://zdev.7a64-zdev-1252710547/flutter/data.txt';
      await storage.downloadFile(fileId: fileId, savePath: savePath, onProcess: (count, total) {
        print(count);
        print(total);
      });
      print('下载文件完成');
    });

    test('getUploadMetadata', () async {
      CloudBaseStorage storage = CloudBaseStorage(_core);
      CloudBaseStorageRes<UploadMetadata> res =
          await storage.getUploadMetadata('test/index.txt');
      assert(res.requestId.isNotEmpty);
      assert(res.data.url.isNotEmpty);
    });

    test('getFileDownloadURL', () async {
      CloudBaseStorage storage = CloudBaseStorage(_core);
      List<String> fileIds = [
        'cloud://dev-97eb6c.6465-dev-97eb6c-1252710547/flutter/data.txt'
      ];
      CloudBaseStorageRes<List<DownloadMetadata>> res =
          await storage.getFileDownloadURL(fileIds);
      assert(res.requestId.isNotEmpty);
      assert(res.data.length >= 0);
    });

    test('deleteFiles', () async {
      CloudBaseStorage storage = CloudBaseStorage(_core);
      String fileId =
          'cloud://dev-97eb6c.6465-dev-97eb6c-1252710547/flutter/data.txt';
      CloudBaseStorageRes<List<DeleteMetadata>> res =
          await storage.deleteFiles([fileId]);
      assert(res.requestId.isNotEmpty);
      assert(res.data.length >= 0);
    });
  }

  _listFiles() async {
    String docPath = await _getDocumentsPath();
    Directory dir = Directory(docPath);
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      print(fileOrDir);
    }
  }

  _wxLogin() async {
    CloudBaseAuth auth = CloudBaseWxAuth(_core);
    if (await auth.isLogin()) {
      setState(() {
        _text = '微信已登录';
      });
    } else {
      await auth.login().then((success) {
        setState(() {
          _text = '微信登录成功';
        });
      })
      .catchError((e) {
        setState(() {
          _text = e.toString();
        });
      });
    }
  }

  _anonymousLogin() async {
    CloudBaseAuth auth = CloudBaseAuth(_core);
    CloudBaseAuthState authState = await auth.getAuthState().catchError((e) {
      _text = e.toString();
    });

    if (authState != null && authState.authType == CloudBaseAuthType.ANONYMOUS) {
      setState(() {
        _text = '匿名登录态已存在';
      });
    } else {
      await auth.signInAnonymously().then((success) {
        setState(() {
          _text = '匿名登录成功';
        });
      }).catchError((e) {
        setState(() {
          _text = e.toString();
        });
      });
    }
  }
  
  _customLogin() async {
    CloudBaseAuth auth = CloudBaseAuth(_core);
    CloudBaseAuthState authState = await auth.getAuthState().catchError((e) {
      _text = e.toString();
    });

    if (authState != null && authState.authType == CloudBaseAuthType.CUSTOM) {
      _text = '自定义登录态已存在';
    } else {
      Dio dio = Dio(BaseOptions(
          headers: {
            'Connection': 'Keep-Alive',
            'User-Agent': 'cloudbase-flutter-sdk/0.0.1'
          },
          contentType: 'application/json',
          responseType: ResponseType.json,
          queryParameters: {'env': _core.config.envId},
          sendTimeout: 3000));
      Response response = await dio.post('https://test-cloud-f7c3g.service.tcloudbase.com/getTicket');
      String ticket = response.data['ticket'];

      await auth.signInWithTicket(ticket).then((success) {
        setState(() {
          _text = '自定义登录成功';
        });
      }).catchError((e) {
        setState(() {
          _text = '自定义登录失败：${e.toString()}';
        });
      });
    }
  }

  _getUserInfo() async {
    CloudBaseAuth auth = CloudBaseAuth(_core);
    await auth.getUserInfo().then((userInfo) {
      setState(() {
        _text = userInfo.toString();
      });
    })
    .catchError((e) {
      setState(() {
        _text = e.toString();
      });
    });
  }

  _signOut() async {
    CloudBaseAuth auth = CloudBaseAuth(_core);
    await auth.signOut().then((success) {
      setState(() {
        _text = '退出登录成功';
      });
    })
    .catchError((e) {
      setState(() {
        _text = e.toString();
      });
    });
  }

  _callFunctionTest() async {
    CloudBaseWxAuth(_core);
    CloudBaseFunction cloudbaseFunc = CloudBaseFunction(_core);

    test('callFunction 参数', () async {
      Map<String, dynamic> data = {'a': 1, 'b': 2};

      CloudBaseResponse res1 = await cloudbaseFunc.callFunction('sum', data);
      print('res1: $res1');
      assert(res1.requestId.isNotEmpty);
      assert(res1.data.isNotEmpty);
      assert(res1.data['sum'] == 3);
    });

    test('callFunction 无参数', () async {
      CloudBaseResponse res2 = await cloudbaseFunc.callFunction('return');
      print('res2: $res2');
      assert(res2.requestId.isNotEmpty);
      assert(res2.data.isNotEmpty);
    });

    setState(() {
      _text = '调用测试通过';
    });
  }

  _fileTest() {
    CloudBaseWxAuth(_core);
    _testFile();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  '$_text',
                ),
              ),
              buildButton('微信登录', _wxLogin),
              buildButton('匿名登录', _anonymousLogin),
              buildButton('自定义登录', _customLogin),
              buildButton('获取用户信息', _getUserInfo),
              buildButton('调用函数测试', _callFunctionTest),
              buildButton('文件测试', _fileTest),
              buildButton('退出登录', _signOut),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

Widget buildButton(String text, void Function() onPressed) {
  ButtonTheme button = ButtonTheme(
      minWidth: 150,
      child: FlatButton(
        key: Key(text),
        color: MainColor,
        textColor: Colors.white,
        padding: EdgeInsets.all(4.0),
        splashColor: MainColor,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 15.0),
        ),
      ));
  return button;
}
