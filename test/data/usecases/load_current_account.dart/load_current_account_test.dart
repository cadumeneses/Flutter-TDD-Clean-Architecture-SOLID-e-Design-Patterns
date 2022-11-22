import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalCurrentAccount({required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
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

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
  });
  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token'));
  });
}
