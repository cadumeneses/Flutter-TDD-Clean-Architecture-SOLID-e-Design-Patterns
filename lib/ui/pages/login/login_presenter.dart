abstract class LoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<bool> get isFormValidStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
}