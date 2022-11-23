import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    mockSave();
  }
  When mockSaveCall() =>
      when(() => write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() =>
      when(() => write(key: any(named: 'key'), value: any(named: 'value')))
          .thenThrow(Exception());
  
  When mockFetchCall() => when(() => read(key: any(named: 'key')));
  void mockFetch(String? key) => mockFetchCall().thenAnswer((_) async => key);
}

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late LocalStorageAdapter sut;
  String? key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    secureStorage.mockFetch(key);
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key!, value: value);

      verify(() => secureStorage.write(key: key!, value: value));
    });

    test('Should throw if save secure throws', () async {
      secureStorage.mockSaveError();
      final future = sut.saveSecure(key: key!, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  }); 

  group('fetchSecure', () {
    test('Should call fetch secure with correct values', () async {
      await sut.fetchSecure(key!);

      verify(() => secureStorage.read(key: key!));
    });
  }); 
}
