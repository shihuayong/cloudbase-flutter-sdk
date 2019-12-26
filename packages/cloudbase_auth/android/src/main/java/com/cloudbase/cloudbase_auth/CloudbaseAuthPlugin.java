package com.cloudbase.cloudbase_auth;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Map;

/** CloudbaseAuthPlugin */
public class CloudbaseAuthPlugin implements FlutterPlugin, MethodCallHandler {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "cloudbase_auth");
    channel.setMethodCallHandler(new CloudbaseAuthPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "cloudbase_auth");
    channel.setMethodCallHandler(new CloudbaseAuthPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
    switch (call.method) {
      case "wxauth.register":
        handleWxAuthRegister(call, result);
        break;
      case "wxauth.login":
        handleWxAuthLogin(call, result);
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  private void handleWxAuthRegister(MethodCall call, Result result) {
    Map<String, String> arguments = call.arguments();
    String wxAppId = arguments.get("wxAppId");
    CloudbaseWxAuth wxAuth = CloudbaseWxAuth.initialize(wxAppId);
    if (wxAuth != null) {
      result.success(null);
    } else {
      //todo: 补充错误码
      result.error("wxAuthInitFailed", null, null);
    }
  }

  private void handleWxAuthLogin(MethodCall call, Result result) {
    CloudbaseWxAuth wxAuth = CloudbaseWxAuth.getInstance();
    if (wxAuth != null) {
      wxAuth.login();
      result.success(null);
    } else {
      result.error("wxAuthNoInstance", null, null);
    }
  }
}
