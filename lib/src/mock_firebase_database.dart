import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:mockito/mockito.dart';

import 'mock_database_reference.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {
  static FirebaseDatabase get instance => MockFirebaseDatabase();

  static get persistData => _persistData;

  final Map<String, dynamic> _persistedData = <String, dynamic>{};
  final _streamController = StreamController<DatabaseEvent>();

  @override
  DatabaseReference reference() => ref();

  @override
  DatabaseReference ref([String? path]) {
    if (path != null) {
      return MockDatabaseReference(
        _streamController,
        _persistedData,
      ).child(path);
    }
    return MockDatabaseReference(_streamController, _persistedData);
  }

  // ignore: unused_field
  static bool _persistData = true;

  //Todo support non persistence.
  static void setDataPersistanceEnabled({bool ennabled = true}) {
    _persistData = ennabled;
  }
}
