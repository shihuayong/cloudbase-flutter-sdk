import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/src/geo/lineString.dart';

class MultiLineString {
  List<LineString> lines;

  MultiLineString(this.lines) {
    if (lines.length == 0) {
      throw new CloudBaseException(code: CloudBaseExceptionCode.INVALID_PARAM, message: 'MultiLineString must contain 1 linestring at least');
    }
  }

  Map toJson() {
    var lineArr = [];
    lines.forEach((line) {
      lineArr.add(line.toJson()['coordinates']);
    });

    return {
      'type': 'MultiLineString',
      'coordinates': lineArr
    };
  }

  static bool validate(data) {
    return true;
  }

  static MultiLineString fromJson(coordinates) {
    List<LineString> lines = [];
    coordinates.forEach((line) {
      lines.add(LineString.fromJson(line));
    });

    return MultiLineString(lines);
  }
}