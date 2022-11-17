import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd/main/factories/pages/login/login.dart';
import 'package:flutter_tdd/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      const RequiredFieldValidation('email'),
      const EmailValidation('email'),
      const RequiredFieldValidation('password'),
    ]);
  });
}
