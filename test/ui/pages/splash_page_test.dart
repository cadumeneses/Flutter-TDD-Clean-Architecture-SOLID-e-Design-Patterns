import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;
  const SplashPage({required this.presenter, super.key});

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('4Dev'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}

class SplashPrensenterSpy extends Mock implements SplashPresenter {
  SplashPrensenterSpy() {
    when(() => loadCurrentAccount()).thenAnswer((_) async => _);
  }
}

void main() {
  late SplashPrensenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPrensenterSpy();

    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage(presenter: presenter))
      ],
    ));
  }

  testWidgets('Should presenter spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadCurrentAccount()).called(1);
  });
}
