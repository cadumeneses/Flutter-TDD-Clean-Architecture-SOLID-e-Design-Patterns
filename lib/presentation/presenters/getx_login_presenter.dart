import 'package:flutter_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecase.dart';
import '../../domain/helpers/domain.error.dart';

import '../protocols/protocols.dart';

class LoginState {}

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;

  final _emailError = Rx<String?>(null);
  final _passwordError = Rx<String?>(null);
  final _mainError = Rx<String?>(null);
  final _navigateTo = Rx<String?>('');
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  @override
  Stream<String?> get emailErrorStream => _emailError.stream;
  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<String?> get mainErrorStream => _mainError.stream;
  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      _isLoading.value = true;
      _validateForm();
      final account = await authentication.auth(
        AuthenticationParams(email: _email!, password: _password!),
      );
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (e) {
      _mainError.value = e.description;
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
