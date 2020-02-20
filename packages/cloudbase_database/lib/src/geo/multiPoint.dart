import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/src/geo/point.dart';

class MultiPoint {
  List<Point> points;

  MultiPoint(this.points) {
    if (points.length <= 0) {
      throw CloudBaseException(code: CloudBaseExceptionCode.INVALID_PARAM, message: 'points must contain 1 point at least');
    }
  }

  Map<String, dynamic> toJson() {
    var pointArr = [];
    points.forEach((point) {
      pointArr.add(point.toJson()['coordinates']);
    });

    return {
      'type': 'MultiPoint',
      'coordinates': pointArr
    };
  }

  static bool validate(data) {
    return true;
  }

  static MultiPoint fromJson(coordinates) {
    List<Point> points = [];
    coordinates.forEach((point) {
      points.add(Point.fromJson(point));
    });

    return MultiPoint(points);
  }
}