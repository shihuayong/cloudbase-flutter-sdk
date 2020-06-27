class SortedKeyValue {
  List<String> keys = [];
  List<dynamic> values = [];
  List<List<dynamic>> pairs = [];

  Map<String, dynamic> _obj = {};

  SortedKeyValue( obj, [List<String> selectkeys]) {
    if (!(obj is Map)) {
      return;
    }

    (obj as Map<String, dynamic> ?? {}).keys.toList()
    ..sort((a, b) {
      // final localeA = Intl.message(a, locale: 'en');
      // final localeB = Intl.message(b, locale: 'en');

      // print(localeA);
      // print(localeB);

      // return localeA.compareTo(localeB);
      return (a.toLowerCase().trim().compareTo(b.toLowerCase().trim()));

    })
    ..forEach((key) {
      if (selectkeys?.contains(key) ?? true) {
        this.keys.add(key);
        this.values.add(obj[key]);
        this.pairs.add([key, obj[key]]);
        this._obj[key.toLowerCase()] = obj[key];
      }
    });
  }

  dynamic get(String key) {
    return this._obj[key];
  }

  @override
  String toString({
    String kvSeparator = '=',
    String joinSeparator = '&'
  }) {
    return this.pairs.map((pair) {
      return pair.join(kvSeparator);
    }).join(joinSeparator);
  }
}