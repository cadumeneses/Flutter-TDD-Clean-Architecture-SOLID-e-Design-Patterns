import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tdd/domain/usecases/usecase.dart';
import 'package:flutter_tdd/domain/helpers/helpers.dart';

import 'package:flutter_tdd/data/http/http.dart';
import 'package:flutter_tdd/data/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  When mockRequest() => when(() => httpClient.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body')));

  void mockHttp(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttp(mockValidData());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {
            'name': params.name,
            'email': params.email,
            'password': params.password,
            'passwordConfirmation': params.passwordConfirmation,
          },
        ));
  });

  test('Should throw UnexpectedError if httpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if httpClient returns 403',
      () async {
    mockHttpError(HttpError.forbiden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttp(validData);

    final account = await sut.add(params);
    
    expect(account.token, validData['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttp({'invalid_key': 'invalid_value'});
    
    final future = sut.add(params);
    
    expect(future, throwsA(DomainError.unexpected));
  });
}
