import './base.dart';

enum CloudBaseAuthType {
  /// 未登录
  EMPTY,

  /// 微信登录
  WX,

  /// 自定义登录
  CUSTOM,

  /// 匿名登录
  ANONYMOUS
}

abstract class ICloudBaseAuth {
  /// 获取 authType
  CloudBaseAuthType getAuthType();

  /// 获取 accessToken
  Future<String> getAccessToken();
}

class CloudBaseEmptyAuth implements ICloudBaseAuth {
  String accessToken;

  CloudBaseCore core;

  CloudBaseAuthType type = CloudBaseAuthType.EMPTY;

  CloudBaseEmptyAuth(CloudBaseCore core);

  CloudBaseAuthType getAuthType() {
    return type;
  }

  Future<String> getAccessToken() {
    return Future.value(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoie1wibG9naW5UeXBlXCI6XCJDVVNUT01cIixcImVudk5hbWVcIjpcImRldi05N2ViNmNcIixcInV1aWRcIjpcIjMyODhhMmNiNzEyMzRlYmQ4OGY4OTNjMDdlYzczMzVlXCIsXCJjdXN0b21Vc2VySWRcIjpcInRjYjAwXCJ9IiwiaWF0IjoxNTc4MDE3MjY0LCJleHAiOjE1NzgwMjA4NjR9.R9oy2zYDsBd3qePpf4N4FjmQtPMZYnt3WaS78YAqgIk;1577937663');
  }
}
