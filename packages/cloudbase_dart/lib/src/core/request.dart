import 'package:dio/dio.dart';

import './base.dart';
import '../sign/signer.dart';
import './utils.dart';

const int _TCB_DEFAULT_TIMEOUT = 15000;
const String _VERSION = '0.0.1';
const String _DATA_VERSION = '2020-06-01';
const String _TCB_ADMIN_HOST = 'tcb-admin.tencentcloudapi.com';
const String _TCB_ADMIN_HOST_IN_TCB_RUNTIME = 'tcb-admin.tencentyun.com';
const String _TCB_ADMIN_PATH = '/admin';

class CloudBaseRequest {
  Dio _dio;
  CloudBaseCore _core;
  String _url;

  CloudBaseRequest(CloudBaseCore core) {
    _core = core;

    _dio = Dio();

    _url = Utils.checkIsInTcbRuntime()
        ? 'http://$_TCB_ADMIN_HOST_IN_TCB_RUNTIME$_TCB_ADMIN_PATH'
        : 'https://$_TCB_ADMIN_HOST$_TCB_ADMIN_PATH';
  }

  /// 发送请求，携带 accessToken
  Future<CloudBaseResponse> post(
      String action, Map<String, dynamic> data) async {
    data.addAll({
      'action': action,
      'env': _core.config.env,
      'envName': _core.config.env,
      'sdk_version': _VERSION,
      'dataVersion': _DATA_VERSION,
    });

    final Response response = await _dio.post(this._url,
        data: data,
        queryParameters: {'env': this._core.config.env},
        options: Options(
            headers: this._getHeader('POST', data, true),
            contentType: 'application/json',
            responseType: ResponseType.json,
            sendTimeout: this._core.config.timeout ?? _TCB_DEFAULT_TIMEOUT));

    // 从 HTTP 响应 data 中解析数据
    return CloudBaseResponse.fromMap(response.data);
  }

  _getHeader(String method, params, bool withSignedParams) {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'cloudbase-dart-sdk/$_VERSION',
      'X-SDK-Version': 'cloudbase-dart-sdk/$_VERSION',
      'Host': Uri.parse(this._url).host,
    };
    final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    final signInfo = Signer.sign(
        secretId: this._core.config.secretId,
        secretKey: this._core.config.secretKey,
        method: method.toLowerCase(),
        url: '${this._url}?env=${this._core.config.env}',
        headers: headers,
        params: params,
        timestamp: timestamp,
        withSignedParams: withSignedParams);

    headers['Authorization'] = signInfo['authorization'];
    headers['X-Signature-Expires'] = 600;
    headers['X-Timestamp'] = signInfo['timestamp'];

    return headers;
  }
}
