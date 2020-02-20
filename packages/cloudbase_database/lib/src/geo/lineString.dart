import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/src/geo/point.dart';

class LineString {
  List<Point> points;

  LineString(this.points) {
    if (points.length < 2) {
      throw CloudBaseException(code: CloudBaseExceptionCode.INVALID_PARAM, message: 'points must contain 2 points at least');
    }
  }

  Map<String, dynamic> toJson() {
    var pointArr = [];
    points.forEach((point) {
      pointArr.add(point.toJson()['coordinates']);
    });

    return {
      'type': 'LineString',
      'coordinates': pointArr
    };
  }

  static bool validate(data) {
    return true;
  }

  static LineString fromJson(coordinates) {
    List<Point> points = [];
    coordinates.forEach((point) {
      points.add(Point.fromJson(point));
    });

    return LineString(points);
  }
}