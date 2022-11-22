import 'package:flutter_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd/domain/entities/entities.dart';
import 'package:flutter_tdd/domain/usecases/usecase.dart';
import 'package:flutter_tdd/domain/helpers/helpers.dart';

import 'package:flutter_tdd/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {
  SaveCurrentAccountSpy() {
    mockSave();
    mockSaveError();
  }

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(DomainError.unexpected);
}

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => auth(any()));
  void mockAuthentication(AccountEntity data) =>
      mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);
}

class FakeParams extends Fake implements AuthenticationParams {}

class FakeAccount extends Fake implements AccountEntity {}

void main() {
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late GetxLoginPresenter sut;
  late String email;
  late String password;
  late AccountEntity account;
  late SaveCurrentAccountSpy saveCurrentAccount;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUpAll(() {
    registerFallbackValue(FakeParams());
    registerFallbackValue(FakeAccount());
  });

  setUp(() {
    validation = ValidationSpy();
    account = FakeAccount();
    saveCurrentAccount = SaveCurrentAccountSpy();
    authentication = AuthenticationSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    authentication.mockAuthentication(account);
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);
    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit Password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emits password null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emits form invalid event if any field is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emits form vaalid event is form valid', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(
      () => authentication.auth(
        AuthenticationParams(email: email, password: password),
      ),
    ).called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit UnecpectedError if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredencialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredecials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais Inválidas')));

    await sut.auth();
  });

  test('Should emit correct events on UnecpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });
}
