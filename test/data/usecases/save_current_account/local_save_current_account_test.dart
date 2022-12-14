import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:flutter_tdd/domain/helpers/helpers.dart';
import 'package:flutter_tdd/domain/entities/account_entity.dart';

import 'package:flutter_tdd/data/usecases/usecases.dart';
import 'package:flutter_tdd/data/cache/cache.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
  SaveSecureCacheStorageSpy() {
    mockSave();
  }

  When mockSaveCall() => when(
      () => saveSecure(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
}

void main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(() => saveSecureCacheStorage.saveSecure(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenThrow(Exception());
  }

  test('Should call SaveCacheStorage with correct values', () async {
    await sut.save(account);

    verify(() =>
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnnexpectedError if SaveCacheStorage throws', () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
