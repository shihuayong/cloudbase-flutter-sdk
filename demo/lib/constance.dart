import 'package:flutter/material.dart';

const Map<int, Color> colorMap = {
  50: Color.fromRGBO(2, 110, 255, .1),
  100: Color.fromRGBO(2, 110, 255, .2),
  200: Color.fromRGBO(2, 110, 255, .3),
  300: Color.fromRGBO(2, 110, 255, .4),
  400: Color.fromRGBO(2, 110, 255, .5),
  500: Color.fromRGBO(2, 110, 255, .6),
  600: Color.fromRGBO(2, 110, 255, .7),
  700: Color.fromRGBO(2, 110, 255, .8),
  800: Color.fromRGBO(2, 110, 255, .9),
  900: Color.fromRGBO(2, 110, 255, 1),
};

// 腾讯云 - 蓝色
const MainMaterialColor = const MaterialColor(0xff006eff, colorMap);
const MainColor = const Color(0xff006eff);

const baseConfig = {
  'envId': 'zdev', 
  'wxAppId': 'wx83757a683cf405fe', 
  'wxUniLink': 'https://test-cloud-5f25f8.tcloudbaseapp.com/'
};