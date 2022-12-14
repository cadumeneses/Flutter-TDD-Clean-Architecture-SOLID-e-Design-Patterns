import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tdd/domain/usecases/authentication.dart';
import 'package:flutter_tdd/domain/helpers/domain.error.dart';

import 'package:flutter_tdd/data/usecases/authentication/remote_authentication.dart';
import 'package:flutter_tdd/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  setUp(() {});
  test('Should call HttpClient with correct values', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {
              'accessToken': faker.guid.guid(),
              'name': faker.person.name(),
            });

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    ));
  });

  test('Should throw UnexpectedError if httpClient returns 400', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 404', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if httpClient returns 500', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredencialsError if httpClient returns 401',
      () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredecials));
  });

  test('Should return an Account if httpClient returns 200', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    final accessToken = faker.guid.guid();

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {
              'accessToken': accessToken,
              'name': faker.person.name(),
            });

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test(
      'Should throw UnexpectedError if httpClient returns 200 with invalid data',
      () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {
              'invalild_token': 'invalid_value',
            });

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
