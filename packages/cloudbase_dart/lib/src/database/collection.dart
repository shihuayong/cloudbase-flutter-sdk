import '../../cloudbase_dart.dart';
import 'document.dart';
import 'query.dart';
import 'response.dart';
import 'validater.dart';

class Collection extends Query {

  Collection(CloudBaseCore core, String collName) : super(core: core, coll: collName);

  String get name {
    return super.coll;
  }

  Document doc([docId]) {
    if (docId != null) {
      Validater.isDocId(docId);
    }

    return Document(
      core: super.core,
      coll: super.coll,
      docId: docId
    );
  }

  Future<DbCreateResponse> add(dynamic data) {
    Document doc = this.doc();
    return doc.create(data);
  }



}