import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/src/geo/lineString.dart';

class Polygon {
  List<LineString> lines;

  Polygon(this.lines) {
    if (lines.length == 0) {
      throw new CloudBaseException(code: CloudBaseExceptionCode.INVALID_PARAM, message: 'Polygon must contain 1 linestring at least');
    }
  }

  Map<String, dynamic> toJson() {
    var lineArr = [];
    lines.forEach((line) {
      lineArr.add(line.toJson()['coordinates']);
    });

    return {
      'type': 'Polygon',
      'coordinates': lineArr
    };
  }

  static bool validate(data) {
    return true;
  }

  static Polygon fromJson(coordinates) {
    List<LineString> lines = [];
    coordinates.forEach((line) {
      lines.add(LineString.fromJson(line));
    });

    return Polygon(lines);
  }
}