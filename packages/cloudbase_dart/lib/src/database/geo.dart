import 'geo/lineString.dart';
import 'geo/multiLineString.dart';
import 'geo/multiPoint.dart';
import 'geo/multiPolygon.dart';
import 'geo/point.dart';
import 'geo/polygon.dart';

class Geo {
  Point point(num longitude, num latitude) {
    return Point(longitude, latitude);
  }

  MultiPoint multiPoint(List<Point> points) {
    return new MultiPoint(points);
  }

  LineString lineString(List<Point> points) {
    return new LineString(points);
  }

  MultiLineString multiLineString(List<LineString> lines) {
    return new MultiLineString(lines);
  }

  Polygon polygon (List<LineString> lines) {
    return new Polygon(lines);
  }

  MultiPolygon multiPolygon (List<Polygon> polygons) {
    return new MultiPolygon(polygons);
  }
}