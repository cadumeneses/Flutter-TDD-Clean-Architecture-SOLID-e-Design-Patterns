import 'package:flutter_tdd/validation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String? validate(String? value){
    return null;
  }
}

void main(){
  late EmailValidation sut;

  setUp((){
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', (){
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', (){
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', (){
    expect(sut.validate('carloseduardoms646@gmail.com'), null);
  });
}