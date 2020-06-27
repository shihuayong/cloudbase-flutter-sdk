import 'keyvalue.dart';
import 'utils.dart';

const HOST_KEY = 'host';
const CONTENT_TYPE_KEY = 'content-type';
const MIME_MULTIPART_FORM_DATA = 'multipart/form-data';
const MIME_APPLICATION_JSON = 'application/json';

class Signer {
  /// credential
  String secretId;
  String secretKey;

  String service;

  String algorithm;

  /// signer options
  bool allowSignBuffer;

  Signer({
    this.secretId,
    this.secretKey,
    this.service,
    this.allowSignBuffer 
  }) {
    this.algorithm = 'TC3-HMAC-SHA256';
  }

  bool _isStream(obj) {
    return (obj is Stream);
  }

  bool _isBuffer(obj) {
    return (obj is List<int>);
  }

  _camSafeUrlEncode(String str) {
    return Uri.encodeComponent(str)
      .replaceAll('!', '%21')
      .replaceAll('\'', '%27')
      .replaceAll('(', '%28')
      .replaceAll(')', '%29')
      .replaceAll('*', '%2A');
  }

  /// 将一个对象处理成 KeyValue 形式，嵌套的对象将会被处理成字符串，Key转换成小写字母
  _formatKeyAndValue(obj, {
    bool multipart: false,
    bool enableValueToLowerCase: false,
    List<String> selectedKeys
  }) {
    if (!(obj is Map)) {
      return obj;
    }

    /// enableValueToLowerCase：头部字段，要求小写，其他数据不需要小写，所以这里避免转小写
    
    final kv = Map<String, String>();
    
    (obj as Map<String, dynamic> ?? {}).forEach((key, value) {
      /// NOTE: 客户端类型在服务端可能会丢失
      final lowercaseKey = _camSafeUrlEncode(key.toLowerCase().trim());
      /// 过滤 Key，服务端接收到的数据，可能含有未签名的 Key，通常是签名的时候被过滤掉的流，数据量可能会比较大
      /// 所以这里提供一个过滤的判断，避免不必要的计算
      /// istanbul ignore next
      if (selectedKeys != null && !selectedKeys.contains(lowercaseKey)) {
        return;
      }
      /// istanbul ignore next
      if (value != null) {
        if (lowercaseKey == CONTENT_TYPE_KEY) {
          // multipart/form-data; boundary=???
          if ((value as String).startsWith(MIME_MULTIPART_FORM_DATA)) {
            kv[lowercaseKey] = MIME_MULTIPART_FORM_DATA;
          } 
          else {
            kv[lowercaseKey] = value;
          }
          return;
        }

        if (_isStream(value)) {
          /// 这里如果是个文件流，在发送的时候可以识别
          /// 服务端接收到数据之后传到这里判断不出来的
          /// 所以会进入后边的逻辑
          return;
        }
        else if (_isBuffer(value)) {
          if (multipart) {
            kv[lowercaseKey] = value;
          }
          else {
            kv[lowercaseKey] = enableValueToLowerCase
              ? Utils.stringify(value).trim().toLowerCase()
              : Utils.stringify(value).trim();
          }
        }
        else {
          kv[lowercaseKey] = enableValueToLowerCase
            ? Utils.stringify(value).trim().toLowerCase()
            : Utils.stringify(value).trim();
        }
      }
    });
    
    return kv;
  }

  String _calcParamsHash(params, List<String> keys) {
    if (params is String) {
      return Utils.sha256hash(params).toString();
    }
    /// 只关心业务参数，不关心以什么类型的 Content-Type 传递的
    /// 所以 application/json multipart/form-data 计算方式是相同的
    keys = keys ?? SortedKeyValue(params).keys;

    String query = '';
    keys.forEach((key) {
      if (params[key] != null && params[key] != '' && !_isStream(params[key])) {
        query += '&$key=${params[key]}\r\n';
      }
    });

    return Utils.sha256hash(query).toString();
  }

  /// 计算签名信息
  tc3sign({
    String method,
    String url,
    headers,
    params,
    num timestamp,
    options: const {}
  }) {
    final urlInfo = Uri.parse(url);
    final formatedHeaders = _formatKeyAndValue(headers, enableValueToLowerCase: true);
    final headerKV = SortedKeyValue(formatedHeaders);
    final signedHeaders = headerKV.keys;
    final canonicalHeaders = headerKV.toString(
      kvSeparator: ':',
      joinSeparator: '\n'
    ) + '\n';

    final enableHostCheck = options['enableHostCheck'] ?? true;
    final enableContentTypeCheck = options['enableContentTypeCheck'] ?? true;

    if (enableHostCheck && headerKV.get(HOST_KEY) != urlInfo.host) {
      throw Exception('host:${urlInfo.host} in url must be equals to host:${headerKV.get('host')} in headers');
    }
    if (enableContentTypeCheck && headerKV.get(CONTENT_TYPE_KEY) == null) {
      throw Exception('${CONTENT_TYPE_KEY} field must in headers');
    }

    final multipart = headerKV.get(CONTENT_TYPE_KEY)?.startsWith(MIME_MULTIPART_FORM_DATA) ?? false;
    final formatedParams = method.toUpperCase() == 'GET' ? '' : _formatKeyAndValue(params, multipart: multipart);
    final paramKV = SortedKeyValue(formatedParams);
    final signedParams = paramKV.keys;
    final hashedPayload = _calcParamsHash(formatedParams, null);

    final signedUrl = url.replaceAll(RegExp(r"^https?:"), "").split("?")[0];

    final canonicalRequest = [
      method,
      signedUrl,
      urlInfo.query ?? '',
      canonicalHeaders,
      signedHeaders.join(';'),
      hashedPayload
    ].join('\n');
    
    final date = Utils.formateDate(timestamp);
    final service = this.service;
    final algorithm = this.algorithm;
    final credentialScope = '$date/$service/tc3_request';

    final stringToSign = [
      algorithm,
      timestamp,
      credentialScope,
      Utils.sha256hash(canonicalRequest)
    ].join('\n');

    final secretDate = Utils.sha256hmac(date, 'TC3${this.secretKey}');
    final secretService = Utils.sha256hmac(service, secretDate);
    final secretSignning = Utils.sha256hmac('tc3_request', secretService);
    final signature = Utils.sha256hmac(stringToSign, secretSignning);
    
    final withSignedParams = options['withSignedParams'] ?? false;
    final signedParamsStr = ' SignedParams=${signedParams.join(';')},';

    final authorization = '$algorithm Credential=${this.secretId}/$credentialScope,${withSignedParams ? signedParamsStr : ''} SignedHeaders=${signedHeaders.join(';')}, Signature=$signature';

    return {
      'authorization': authorization,
      'signedParams': signedParams,
      'signedHeaders': signedHeaders,
      'signature': signature.toString(),
      'timestamp': timestamp,
      'multipart': multipart
    };
  }

  static sign({
    String secretId,
    String secretKey,
    String method,
    String url,
    headers,
    params,
    int timestamp,
    bool withSignedParams
  }) {
    final singer = Signer(
      secretId: secretId,
      secretKey: secretKey,
      service: 'tcb'
    );

    final signatureInfo = singer.tc3sign(
      method: method,
      url: url,
      headers: headers ?? {},
      params: params ?? {},
      timestamp: timestamp,
      options: {
        'withSignedParams': withSignedParams
      }
    );

    return {
      'authorization': signatureInfo['authorization'],
      'timestamp': signatureInfo['timestamp'],
      'multipart': signatureInfo['multipart']
    };
  }
}