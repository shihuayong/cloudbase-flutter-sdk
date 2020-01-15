import './exception.dart';
import './auth.dart';

class CloudBaseConfig {
  /// 请求超时时间
  int timeout;

  /// 环境 id
  String envId;

  /// 使用微信登录时, 必须设置这些属性
  String wxAppId;
  String wxUniLink;

  CloudBaseConfig({this.envId, this.timeout, this.wxAppId});

  CloudBaseConfig.fromMap(Map<String, dynamic> map) {
    timeout = map['timeout'];
    envId = map['envId'];
    wxAppId = map['wxAppId'];
    wxUniLink = map['wxUniLink'];

    assert(envId != null && envId.isNotEmpty);
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

  /// auth 实例
  ICloudBaseAuth auth;

  /// 缓存 core 实例
  static final Map<String, CloudBaseCore> _cache = <String, CloudBaseCore>{};

  CloudBaseCore._internal(CloudBaseConfig config) {
    this.config = config;
    auth = CloudBaseEmptyAuth(this);
  }

  factory CloudBaseCore(CloudBaseConfig config) {
    String envId = config.envId;

    // 没有缓存
    if (envId == null && _cache[envId] == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.INVALID_PARAM,
          message: '环境 $envId 未初始化 CloudBaseCore 实例，请传入 envId');
    }

    return _cache.putIfAbsent(envId, () => CloudBaseCore._internal(config));
  }

  factory CloudBaseCore.init(Map<String, dynamic> map) {
    String envId = map['envId'];

    // 没有缓存
    if (envId == null && _cache[envId] == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.INVALID_PARAM,
          message: '环境 $envId 未初始化 CloudBaseCore 实例，请传入 envId');
    }

    return _cache.putIfAbsent(envId, () {
      CloudBaseConfig config = CloudBaseConfig.fromMap(map);
      return CloudBaseCore._internal(config);
    });
  }

  setAuthInstance(ICloudBaseAuth auth) {
    this.auth = auth;
  }
}
