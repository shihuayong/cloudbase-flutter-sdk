///todo
class Validater {
  static bool isDocId(docId) {
    if(docId is String || docId is num) {
      return true;
    } else {
      /// todo throw
    }
  }

  static bool isFieldPath(String path) {

  }

  static bool isFieldOrder(String direction) {

  }

  static bool isGeopoint(String type, num degree) {

  }

  static bool isUpdateDocumentData(dynamic) {

  }
}