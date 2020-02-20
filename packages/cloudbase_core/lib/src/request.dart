import 'package:cloudbase_core/src/exception.dart';
import 'package:dio/dio.dart';
import './auth.dart';
import './base.dart';

const int _TCB_DEFAULT_TIMEOUT = 15000;
const String _VERSION = '0.0.1';
const String _DATA_VERSION = '2019-06-01';
const String _TCB_WEB_URL = 'https://tcb-api.tencentcloudapi.com/web';

class CloudBaseRequest {
  Dio _dio;
  CloudBaseCore _core;
  ICloudBaseAuth _auth;

  CloudBaseRequest(CloudBaseCore core) {
    _core = core;
    _auth = core.auth;
    int timeout = core.config.timeout != null ? core.config.timeout : _TCB_DEFAULT_TIMEOUT;

    _dio = Dio(BaseOptions(
        headers: {
          'Connection': 'Keep-Alive',
          'User-Agent': 'cloudbase-flutter-sdk/0.0.1'
        },
        contentType: 'application/json',
        responseType: ResponseType.json,
        queryParameters: {'env': core.config.envId},
        sendTimeout: timeout));
  }

  /// 发送请求，携带 accessToken
  Future<CloudBaseResponse> post(
      String action, Map<String, dynamic> data) async {
    // 获取 accesstoken
    String accessToken = await _auth.getAccessToken();

    data.addAll({
      'action': action,
      'env': _core.config.envId,
      'sdk_version': _VERSION,
      'dataVersion': _DATA_VERSION,
      'access_token': accessToken
    });

    final Response response = await _dio.post(_TCB_WEB_URL, data: data);

    // 从 HTTP 响应 data 中解析数据
    return CloudBaseResponse.fromMap(response.data);
  }

  /// 发送请求，不携带 accessToken，使用于登录
  Future<CloudBaseResponse> postWithoutAuth(
      String action, Map<String, dynamic> data) async {
    data.addAll({
      'action': action,
      'env': _core.config.envId,
      'sdk_version': _VERSION,
      'dataVersion': _DATA_VERSION
    });

    final Response response = await _dio.post(_TCB_WEB_URL, data: data);
    return CloudBaseResponse.fromMap({
      'code': response.data['code'],
      'data': response.data,
      'message': response.data['message'],
      'requestId': response.data['requestId']
    });
  }

  /// 使用 form 表单传递文件
  postFileByFormData({
    String url,
    String filePath,
    Map<String, dynamic> metadata,
  }) async {
    if (filePath == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.EMPTY_PARAM,
          message: 'filePath cloud not be empty');
    }

    print(filePath);

    Map<String, dynamic> data = {};
    data.addAll(metadata);
    data.addAll({"file": await MultipartFile.fromFile(filePath)});
    FormData formData = FormData.fromMap(data);
    await _dio.post(url, data: formData);
  }

  download(String url, String savePath) async {
    await _dio.download(url, savePath);
  }
}
