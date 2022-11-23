import 'package:faker/faker.dart';
import 'package:flutter_tdd/domain/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd/domain/entities/entities.dart';
import 'package:flutter_tdd/domain/usecases/usecase.dart';

class LocalCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalCurrentAccount({required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

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
  late LocalCurrentAccount sut;
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
    sut = LocalCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
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
