import 'dart:async';
import 'cache.dart';

import 'package:cloudbase_core/cloudbase_core.dart';

class AuthProvider implements ICloudBaseAuth {
  AuthCache _cache;
  CloudBaseCore _core;
  Future<void> _refreshAccessTokenFuture;
  CloudBaseAuthType _authType;

  AuthProvider(CloudBaseCore core) {
    _core = core;
    _cache = AuthCache.init(core.config);
  }

  AuthCache get cache {
    assert(_cache != null);
    return _cache;
  }

  CloudBaseCore get core {
    assert(_core != null);
    return _core;
  }

  CloudBaseConfig get config {
    assert(_core != null && _core.config != null);
    return _core.config;
  }

  Future<void> setRefreshToken(String refreshToken) async {
    /// refresh token设置前，先清掉 access token
    await cache.removeStore(cache.accessTokenKey);
    await cache.removeStore(cache.accessTokenExpireKey);
    await cache.setStore(cache.refreshTokenKey, refreshToken);
  }

  Future<void> refreshAccessToken() async {
    /// 可能会同时调用多次刷新access token，这里把它们合并成一个
    if (this._refreshAccessTokenFuture == null) {
      /// 没有正在刷新，那么正常执行刷新逻辑
      this._refreshAccessTokenFuture = this._refreshAccessToken();
    }

    await this._refreshAccessTokenFuture;
    this._refreshAccessTokenFuture = null;
  }

  Future<void> _refreshAccessToken() async {
    await cache.removeStore(cache.accessTokenKey);
    await cache.removeStore(cache.accessTokenExpireKey);
    String refreshToken = await cache.getStore(cache.refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      throw CloudBaseException(
        code: CloudBaseExceptionCode.NOT_LOGIN,
        message: '未登录CLoudBase'
      );
    }

    Map<String, dynamic> params = { 'refresh_token': refreshToken };
    /// 匿名登录时传入uuid，若refresh token过期则可根据此uuid进行延期
    CloudBaseAuthType authType = await cache.getStore(cache.loginTypeKey);
    if (authType == CloudBaseAuthType.ANONYMOUS) {
      params['anonymous_uuid'] = await cache.getStore(cache.anonymousUuidKey);
    }
    CloudBaseResponse res = await CloudBaseRequest(this.core).postWithoutAuth('auth.getJwt', params);

    if (res == null) {
      throw new CloudBaseException(
          code: CloudBaseExceptionCode.NULL_RESPONES,
          message: "unknown error, res is null");
    }

    if (res.code != null) {
      throw new CloudBaseException(code: res.code, message: res.message);
    }

    if (res.data != null) {
      if (res.data['access_token'] != null) {
        await cache.setStore(cache.accessTokenKey, res.data['access_token']);
        /// 本地时间可能没有同步
        await cache.setStore(cache.accessTokenExpireKey, res.data["access_token_expire"]+DateTime.now().millisecondsSinceEpoch);
      }

      /// 匿名登录refresh_token过期情况下返回refresh_token
      /// 此场景下使用新的refresh_token获取access_token
      if (res.data['refresh_token'] != null) {
        await cache.removeStore(cache.refreshTokenKey);
        await cache.setStore(cache.refreshTokenKey, res.data['refresh_token']);
        this._refreshAccessToken();
      }
    }
  }

  @override
  Future<CloudBaseAuthType> getAuthType() async {
    if (_authType == null) {
      _authType = await cache.getStore(cache.loginTypeKey);
    }

    return _authType;
  }

  Future<void> setAuthType(CloudBaseAuthType authType) async {
    if (authType != _authType) {
      await cache.setStore(cache.loginTypeKey, authType);
      _authType = authType;
    }
  }


  @override
  Future<String> getAccessToken() async {
    return await cache.getStore(cache.accessTokenKey);
  }
}