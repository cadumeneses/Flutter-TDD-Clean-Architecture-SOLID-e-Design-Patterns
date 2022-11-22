import 'package:flutter_tdd/domain/entities/entities.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}