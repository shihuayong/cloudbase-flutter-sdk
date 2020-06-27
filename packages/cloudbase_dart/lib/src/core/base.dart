import './exception.dart';

class CloudBaseConfig {
  /// 请求超时时间
  int timeout;

  /// 环境 id
  String env;

  /// 环境密钥
  String secretId;
  String secretKey;

  CloudBaseConfig({this.env, this.timeout, this.secretId, this.secretKey}) {
    assert(env != null);
  }

  CloudBaseConfig.fromMap(Map<String, dynamic> map) {
    env = map['env'];
    timeout = map['timeout'];
    secretId = map['secretId'];
    secretKey = map['secretKey'];
  }
}

class CloudBaseResponse {
  dynamic data;
  String code;
  String message;
  String requestId;

  CloudBaseResponse({this.code, this.message, this.data, this.requestId});

  factory CloudBaseResponse.fromMap(Map<String, dynamic> map) {
    return CloudBaseResponse(
        code: map['code'],
        data: map['data'],
        message: map['message'],
        requestId: map['requestId']);
  }

  @override
  String toString() {
    Map<String, dynamic> map = {
      'data': data,
      'code': code,
      'message': message,
      'requestId': requestId
    };
    return map.toString();
  }
}

class CloudBaseCore {
  /// 配置
  CloudBaseConfig config;

  /// 缓存 core 实例
  static final Map<String, CloudBaseCore> _cache = <String, CloudBaseCore>{};

  CloudBaseCore._internal(CloudBaseConfig config) {
    this.config = config;
  }

  factory CloudBaseCore(CloudBaseConfig config) {
    String envId = config.env;

    // 没有缓存
    if (envId == null && _cache[envId] == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.INVALID_PARAM,
          message: '环境 $envId 未初始化 CloudBaseCore 实例，请传入 envId');
    }

    return _cache.putIfAbsent(envId, () => CloudBaseCore._internal(config));
  }

  factory CloudBaseCore.init(Map<String, dynamic> map) {
    String envId = map['env'];

    // 没有缓存
    if (envId == null && _cache[envId] == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.INVALID_PARAM,
          message: 'CloudBase 初始化实例失败，缺少参数 env');
    }

    return _cache.putIfAbsent(envId, () {
      CloudBaseConfig config = CloudBaseConfig.fromMap(map);
      return CloudBaseCore._internal(config);
    });
  }
}
