import 'package:flutter_tdd/domain/usecases/usecase.dart';

import '../../../data/usecases/usecases.dart';
import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeLocalStorageAdapter());
}
