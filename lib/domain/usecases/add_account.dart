import 'package:equatable/equatable.dart';

import 'package:flutter_tdd/domain/entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  
  @override
  List<Object> get props => [name, email, password, passwordConfirmation];

  const AddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}
