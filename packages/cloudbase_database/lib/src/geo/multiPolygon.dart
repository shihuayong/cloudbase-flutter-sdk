import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/src/geo/polygon.dart';

class MultiPolygon {
  List<Polygon> polygons;

  MultiPolygon(this.polygons) {
    if (polygons.length <= 0) {
      throw new CloudBaseException(code: CloudBaseExceptionCode.INVALID_PARAM, message: 'MultiPolygon must contain 1 polygon at least');
    }
  }

  Map<String, dynamic> toJson() {
    var polygonArr = [];
    polygons.forEach((polygon) {
      polygonArr.add(polygon.toJson()['coordinates']);
    });

    return {
      'type': 'MultiPolygon',
      'coordinates': polygonArr
    };
  }

  static bool validate(data) {
    return true;
  }

  static MultiPolygon fromJson(coordinates) {
    List<Polygon> polygons = [];
    coordinates.forEach((polygon) {
      polygons.add(Polygon.fromJson(coordinates));
    });

    return MultiPolygon(polygons);
  }
}