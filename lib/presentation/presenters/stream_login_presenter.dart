import 'dart:async';

import 'package:flutter_tdd/domain/usecases/usecase.dart';

import '../protocols/protocols.dart';

class LoginState {
  String? _email;
  String? _password;
  String? emailError;
  String? passwordError;
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      _email != null &&
      _password != null;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;

  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state._email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state._password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }

  Future<void> auth() async {
    await authentication.auth(AuthenticationParams(
        email: _state._email!,
        password: _state._password!,
      ),
    );
  }
}
