import 'package:flutter_tdd/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tdd/domain/usecases/usecase.dart';

import 'package:flutter_tdd/ui/pages/splash/splash.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  final _navigateTo = Rx<String?>(null);

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    try {
    await loadCurrentAccount.load();
    _navigateTo.value = '/surveys';
      
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() => when(() => load());
  void mockLoad({required AccountEntity account}) =>
      mockLoadCall().thenAnswer((_) async => account);
  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}

class FakeAccount extends Fake implements AccountEntity {}

void main() {
  late AccountEntity account;
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;

  setUpAll(() {
    registerFallbackValue(FakeAccount());
  });

  setUp(() {
    account = FakeAccount();
    loadCurrentAccount = LoadCurrentAccountSpy();
    loadCurrentAccount.mockLoad(account: account);
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });

  test('Should go to login page on error', () async {
    loadCurrentAccount.mockLoadError();
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
}
