import 'package:cloudbase_database/src/validater.dart';

class Point {

  /// 纬度 [-90, 90]
  num longitude;

  /// 经度 [-100, 100]
  num latitude;

  Point(this.longitude, this.latitude) {
    Validater.isGeopoint('longitude', longitude);
    Validater.isGeopoint('latitude', latitude);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude]
    };
  }

  static bool validate(data) {
    return true;
  }

  static Point fromJson(coordinates) {
    return Point(coordinates[0], coordinates[1]);
  }
}