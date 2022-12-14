import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd/validation/validators/validators.dart';

void main(){
  late RequiredFieldValidation sut;

  setUp((){
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', (){
    expect(sut.validate('any_null'), null);
  });

  test('Should return error if value is empty', (){
    expect(sut.validate(''), 'Campo obrigatório!');
  });

  test('Should return error if value is null', (){
    expect(sut.validate(null), 'Campo obrigatório!');
  });
}