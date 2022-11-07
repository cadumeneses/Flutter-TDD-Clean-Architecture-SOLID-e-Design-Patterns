import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tdd/domain/usecases/authentication.dart';
import 'package:flutter_tdd/data/usecases/remote_authentication.dart';

import 'package:flutter_tdd/data/http/http_client.dart';

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
}
