import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:flutter_tdd/domain/entities/entities.dart';
import 'package:flutter_tdd/domain/helpers/helpers.dart';

import 'package:flutter_tdd/data/cache/cache.dart';
import 'package:flutter_tdd/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {
  FetchSecureCacheStorageSpy() {
    mockFetch();
  }
  When mockFetchCall() => when(() => fetchSecure('token'));
  void mockFetch() => mockFetchCall().thenAnswer((_) async => _);
}

void main() {
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFetchSecureCall() =>
      when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
