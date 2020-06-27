import 'dart:convert';
import 'package:crypto/crypto.dart';

class Utils {
  static String formateDate(num timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toUtc().toIso8601String().split('T')[0];
  }

  static String stringify(value) {
    return (value is String ? value : jsonEncode(value));
  }

  static Digest sha256hash(String string) {
    return sha256.convert(utf8.encode(string));
  }

  static Digest sha256hmac(String string, secret) {
    final key = secret is Digest ?  secret.bytes : utf8.encode(secret);
    final value = utf8.encode(string);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(value);

    return digest;
  }
}