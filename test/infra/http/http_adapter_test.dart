import 'package:faker/faker.dart';
import 'package:flutter_tdd/data/http/http_error.dart';
import 'package:flutter_tdd/infra/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    mockPost(200);
    mockPut(200);
    mockGet(200);
  }

  When mockPostCall() => when(() => this
      .post(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPostError() => when(() => mockPostCall().thenThrow(Exception()));

  When mockPutCall() => when(() => this
      .put(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPut(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockPutCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPutError() => when(() => mockPutCall().thenThrow(Exception()));

  When mockGetCall() =>
      when(() => this.get(any(), headers: any(named: 'headers')));
  void mockGet(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockGetCall().thenAnswer((_) async => Response(body, statusCode));
  void mockGetError() => when(() => mockGetCall().thenThrow(Exception()));
}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('post', () {
    test('Should call post with correct values', () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});
      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
          url: url,
          method: 'post',
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});
      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });
  });
  test('Should call post withdoout body', () async {
    await sut.request(url: url, method: 'post');
    verify(() => client.post(
          any(),
          headers: any(named: 'headers'),
        ));
  });

  test('Should return data if post returns 200', () async {
    final response = await sut.request(url: url, method: 'post');

    expect(response, {'any_key': 'any_value'});
  });

  test('Should return null if post returns 200 with no data', () async {
    client.mockPost(200, body: '');

    final response = await sut.request(url: url, method: 'post');

    expect(response, null);
  });

  test('Should return null if post returns 204', () async {
    client.mockPost(204, body: '');

    final response = await sut.request(url: url, method: 'post');

    expect(response, null);
  });

  test('Should return null if post returns 204 with data', () async {
    client.mockPost(204);

    final response = await sut.request(url: url, method: 'post');

    expect(response, null);
  });

  test('Should return BadRequestError if post returns 400', () async {
    client.mockPost(400);

    final future = sut.request(url: url, method: 'post');

    expect(future, throwsA(HttpError.badRequest));
  });

  test('Should return ServerError if post returns 500', () async {
    client.mockPost(500);

    final future = sut.request(url: url, method: 'post');

    expect(future, throwsA(HttpError.serverError));
  });

  test('Should return UnauthorizedError if post returns 401', () async {
    client.mockPost(401);

    final future = sut.request(url: url, method: 'post');

    expect(future, throwsA(HttpError.unauthorized));
  });
}
