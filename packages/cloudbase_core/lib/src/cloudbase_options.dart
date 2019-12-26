import 'package:flutter/material.dart' show required;

class CloudbaseOptions {

  final String envId;

  // 使用微信登录时, 必须设置该属性
  final String wxAppId;

  const CloudbaseOptions({
    @required this.envId,
    this.wxAppId
  }) : assert(envId != null);

  CloudbaseOptions.from(Map<dynamic, dynamic> map) 
  : envId = map['envId'],
    wxAppId = map['wxAppId'] {
    assert(envId != null);
  }

  Map<String, String> get asMap {
    return {
      envId: envId,
      wxAppId: wxAppId
    };
  }

  @override
  String toString() => asMap.toString();
}