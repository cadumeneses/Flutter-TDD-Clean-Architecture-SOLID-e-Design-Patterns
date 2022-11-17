import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('carloseduardoms646@gmail.com'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('carloseduardoms646'), 'Campo inválido!');
  });
}
