import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecase.dart';
import '../factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(fetchSecureCacheStorage: makeLocalStorageAdapter());
}
