import 'dart:async';
import 'baseAuth.dart';
import 'wxAuth.dart';
import 'anonymousAuth.dart';
import 'customAuth.dart';
import 'interface.dart';

import 'package:cloudbase_core/cloudbase_core.dart';

class CloudBaseAuth extends AuthProvider {
  WxAuthProvider _wxAuthProvider;
  CustomAuthProvider _customAuthProvider;
  AnonymousAuthProvider _anonymousAuthProvider;

  CloudBaseAuth(CloudBaseCore core) : super(core) {
    super.core.setAuthInstance(this);
  }

  /// 微信登录
  Future<CloudBaseAuthState> signInByWx({String wxAppId, String wxUniLink}) async {
    if (_wxAuthProvider == null) {
      _wxAuthProvider = WxAuthProvider(super.core);
    }

    CloudBaseAuthState authState = await _wxAuthProvider.signInByWx(wxAppId, wxUniLink);

    return authState;
  }

  /// 自定义登录
  Future<CloudBaseAuthState> signInWithTicket(String ticket) async {
    if (_customAuthProvider == null) {
      _customAuthProvider = CustomAuthProvider(super.core);
    }

    CloudBaseAuthState authState = await _customAuthProvider.signInWithTicket(ticket);

    return authState;
  }

  /// 匿名登录
  Future<CloudBaseAuthState> signInAnonymously() async {
    if (_anonymousAuthProvider == null) {
      _anonymousAuthProvider = AnonymousAuthProvider(super.core);
    }

    CloudBaseAuthState authState = await _anonymousAuthProvider.signInAnonymously();

    return authState;
  }

  /// 登出
  Future<void> signOut() async {
    if (await getAuthType() == CloudBaseAuthType.ANONYMOUS) {
      throw CloudBaseException(
        code: CloudBaseExceptionCode.SIGN_OUT_FAILED,
        message: '匿名用户不支持登出操作'
      );
    }

    String refreshToken = await cache.getStore(cache.refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      /// 没有refreshToken, 不需要执行登出操作
      return;
    }

    CloudBaseResponse res = await CloudBaseRequest(super.core).post('auth.logout', {
      'refresh_token': refreshToken
    });

    if (res == null) {
      throw CloudBaseException(
          code: CloudBaseExceptionCode.NULL_RESPONES,
          message: "unknown error, res is null");
    }

    if (res.code != null) {
      throw CloudBaseException(code: res.code, message: res.message);
    }

    await cache.removeStore(cache.refreshTokenKey);
    await cache.removeStore(cache.accessTokenKey);
    await cache.removeStore(cache.accessTokenExpireKey);

    await setAuthType(CloudBaseAuthType.EMPTY);
  }

  /// 获取登录状态
  Future<CloudBaseAuthState> getAuthState() async {
    try {
      await refreshAccessToken();
    } catch (e) {
      return null;
    }

    String accessToken = await cache.getStore(cache.accessTokenKey);
    if (accessToken != null && accessToken.isNotEmpty) {
      return CloudBaseAuthState(
        authType: await cache.getStore(cache.loginTypeKey),
        refreshToken: await cache.getStore(cache.refreshTokenKey),
        accessToken: accessToken
      );
    }

    return null;
  }

  /// 获取用户信息
  Future<CloudBaseUserInfo> getUserInfo() async {
    CloudBaseResponse res = await CloudBaseRequest(super.core).post('auth.getUserInfo', {});

    if (res == null) {
      throw CloudBaseException(
          code: CloudBaseExceptionCode.NULL_RESPONES,
          message: "unknown error, res is null");
    }

    if (res.code != null) {
      throw CloudBaseException(code: res.code, message: res.message);
    }

    return CloudBaseUserInfo(res.data);
  }

  Future<bool> isLogin() {
    /// throw error
  }

  Future<bool> login() {
    /// throw error
  }
}

class CloudBaseWxAuth extends CloudBaseAuth {
  CloudBaseCore _core;

  /// 不再推荐使用CloudBaseWxAuth，会在后续版本废弃
  /// 推荐直接使用CloudBaseAuth
  CloudBaseWxAuth(CloudBaseCore core) : super(core) {
    _core = super.core;
    assert(_core != null);
    assert(_core.config.wxAppId != null && _core.config.wxAppId.isNotEmpty);
    assert(_core.config.wxUniLink != null && _core.config.wxUniLink.isNotEmpty);
    _core.setAuthInstance(this);
  }

  @override
  Future<bool> login() async {
    await super.signInByWx(
        wxAppId: _core.config.wxAppId,
        wxUniLink: _core.config.wxUniLink
    );

    return true;
  }

  @override
  Future<bool> isLogin() async {
    bool isLogin = false;

    CloudBaseAuthState authState = await getAuthState();

    if (authState != null && authState.authType == CloudBaseAuthType.WX) {
      isLogin = true;
    }

    return isLogin;
  }

}