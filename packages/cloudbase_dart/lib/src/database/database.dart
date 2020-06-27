import '../../cloudbase_dart.dart';
import 'geo.dart';
import 'regexp.dart';
import 'serverdate.dart';
import 'command.dart';
import 'collection.dart';

class CloudBaseDatabase {
  CloudBaseCore _core;
  Command _command;
  Geo _geo;

  Command get command {
    return _command;
  }

  Geo get geo {
    return _geo;
  }

  CloudBaseDatabase(CloudBaseCore core) {
    _core = core;
    _command = Command();
    _geo = Geo();
  }

  Collection collection(String name) {
    return Collection(_core, name);
  }

  RegExp regExp(String regexp, [String options]) {
    return RegExp(regexp, options);
  }

  ServerDate serverDate([num offset]) {
    return ServerDate(offset);
  }

}