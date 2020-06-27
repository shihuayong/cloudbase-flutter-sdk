class RegExp {
  String regexp;
  String options;

  RegExp(this.regexp, [this.options]);

  Map<String, dynamic> toJson() {
    return {
      '\$regexp': regexp,
      '\$options': options
    };
  }
}