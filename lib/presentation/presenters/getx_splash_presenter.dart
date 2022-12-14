import 'package:get/get.dart';

import '../../domain/usecases/usecase.dart';

import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  final _navigateTo = Rx<String?>(null);

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));

    try {
      await loadCurrentAccount.load();
      _navigateTo.value = '/surveys';
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }
}
