import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String token;

  List<Object?> get props => [token];

  const AccountEntity(this.token);
}
