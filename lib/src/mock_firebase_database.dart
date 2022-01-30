import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:mockito/mockito.dart';

import 'mock_database_reference.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {
  static FirebaseDatabase get instance => MockFirebaseDatabase();

  static get persistData => _persistData;

  final Map<String, dynamic> _persistedData = <String, dynamic>{};
  final Map<String, dynamic> _streamMap = {};

  @override
  DatabaseReference reference() => ref();

  @override
  DatabaseReference ref([String? path]) {
    final StreamController<DatabaseEvent> controller;
    if (_streamMap.containsKey(path)) {
      controller = _streamMap[path];
    } else {
      controller = StreamController();
      _streamMap.addAll({path ?? '/': controller});
    }

    if (path != null) {
      return MockDatabaseReference(
        controller,
        _persistedData,
      ).child(path);
    }
    return MockDatabaseReference(controller, _persistedData);
  }

  // ignore: unused_field
  static bool _persistData = true;

  //Todo support non persistence.
  static void setDataPersistanceEnabled({bool ennabled = true}) {
    _persistData = ennabled;
  }
}
