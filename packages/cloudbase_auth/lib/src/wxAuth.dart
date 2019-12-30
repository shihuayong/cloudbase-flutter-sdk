import 'dart:async';
import 'baseAuth.dart';

import 'package:flutter/services.dart';
import 'package:cloudbase_core/cloudbase_core.dart';

enum GetAccessTokenType {
  Code,
  RefreshToken
}

class CloudBaseWxAuth extends CloudBaseAuth {
  static const MethodChannel _channel =
      const MethodChannel('cloudbase_auth');

  final String _action = 'auth.getJwt';
  final CloudBaseCore _core;

  CloudBaseWxAuth(this._core) {
    assert(_core != null);
    assert(_core.config.wxAppId != null && _core.config.wxAppId.isNotEmpty);
    assert(_core.config.wxUniLink != null && _core.config.wxUniLink.isNotEmpty);
    _core.setAuthInstance(this);
  }

  @override
  Future<bool> login() async {
    // 0.wx register
    assert(_core.config.wxAppId != null);
    final params = {
      'wxAppId': _core.config.wxAppId,
      'wxUniLink': _core.config.wxUniLink
    };
    await _channel.invokeMethod('wxauth.register', params).catchError((e) {
      throw CloudBaseException(
        code: CloudBaseExceptionCode.AUTH_FAILED,
        message: e.toString()
      );
    });

    // 1.请求wx auth code
    final String code = await _channel.invokeMethod('wxauth.login').catchError((e) {
      throw CloudBaseException(
        code: CloudBaseExceptionCode.AUTH_FAILED,
        message: e.message
      );
    });

    // 2.用code换取access_token和refresh_token
    String accessToken = await _getAccessTokenFromServer(GetAccessTokenType.Code , code);
    if (accessToken == null || accessToken.isEmpty) {
      throw CloudBaseException(
        code: CloudBaseExceptionCode.AUTH_FAILED,
        message: 'wx auth exchange code to access_token failed.'
      );
    }

    return true;
  }

  @override
  Future<bool> isLogin() async {
    bool isLogin = true;
    
    await this.getAccessToken().catchError((e) {
      isLogin = false;
    });
  
    return isLogin;
  }


  // 发送请求，通过 code 或 refreshToken 获取 accessToken
  Future<String> _getAccessTokenFromServer(GetAccessTokenType type, String codeOrRefreshToken) async {
    final Map<String, dynamic> params = {
      'appid': _core.config.wxAppId,
      'loginType': 'WECHAT-OPEN',
    };
    if (type == GetAccessTokenType.Code) {
      params['code'] = codeOrRefreshToken;
    } else if (type == GetAccessTokenType.RefreshToken) {
      params['refresh_token'] = codeOrRefreshToken;
    }

    final CloudBaseRequest cloudbaseRequest = CloudBaseRequest(_core);
    final CloudBaseResponse res = await cloudbaseRequest.postWithoutAuth(_action, params);

    if (res == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.NULL_RESPONES,
          message: "unknown error, res is null");
    }

    if (res.code != null) {
      throw new CloudBaseException(code: res.code, message: res.message);
    }

    final data = res.data;
    final CloudBaseStore store = CloudBaseStore();
    await store.init();
    await store.set('wxauth_access_token', data["access_token"]);
    await store.set('wxauth_access_token_expire', data["access_token_expire"]+DateTime.now().millisecondsSinceEpoch);
    if (type == GetAccessTokenType.Code) {
      await store.set('wxauth_refresh_token', data["refresh_token"]);
    }

    return data["access_token"];
  }

  @override
  Future<String> getAccessToken() async {
    final CloudBaseStore store = await CloudBaseStore().init();
    String accessToken = await store.get('wxauth_access_token');
    int accessTokenExpirt = await store.get('wxauth_access_token_expire');
    String refreshToken = await store.get('wxauth_refresh_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      // 临时token有效
      if (accessTokenExpirt != 0 && accessTokenExpirt > DateTime.now().millisecondsSinceEpoch) {
        return accessToken;
      }
      // 临时token无效，移除
      store.remove('wxauth_access_token');
      store.remove('wxauth_access_token_expire');
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      // refreshToken 有效
      try {
        accessToken = await _getAccessTokenFromServer(GetAccessTokenType.RefreshToken, refreshToken);
        return accessToken;
      } catch (e) {
        // 服务端返回 refreshToken 无效
        store.remove('wxauth_refresh_token');
        throw e;
      }
    }
    
    throw CloudBaseException(code: CloudBaseExceptionCode.REFRESH_TOKEN_EXPIRED, message: '');
  }

  @override
  CloudBaseAuthType getAuthType() {
    return CloudBaseAuthType.WX;
  }

}
