package com.cloudbase.cloudbase_auth;

import android.app.Application;

import androidx.annotation.NonNull;

import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class CloudbaseWxAuth {
  private static CloudbaseWxAuth instance = null;
  private IWXAPI wxApi = null;
  private String wxAppId = "";

  private CloudbaseWxAuth(String wxAppId) {
    this.wxAppId = wxAppId;
    try {
      Application application = (Application) Class.forName("io.flutter.app.FlutterApplication").getMethod("getInitialApplication").invoke(null, (Object[]) null);
      wxApi = WXAPIFactory.createWXAPI(application, wxAppId, true);
    } catch (Exception e) {
      e.printStackTrace();
    }

    if (wxApi != null) {
      wxApi.registerApp(wxAppId);
    }
  }


  public static CloudbaseWxAuth initialize(@NonNull String wxAppId) {
    if (instance != null) {
      return instance;
    }

    instance = new CloudbaseWxAuth(wxAppId);
    return instance;
  }

  public static CloudbaseWxAuth getInstance() {
    return instance;
  }

  public void login() {
    if (wxApi == null) {
      return;
    }

    if (!wxApi.isWXAppInstalled()) {
      // todo: 通知微信未安装
      return;
    }

    final SendAuth.Req req = new SendAuth.Req();
    req.scope = "snsapi_userinfo";
    req.state = "diandi_wx_login";
    wxApi.sendReq(req);
  }
}
