import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final emailErrorController = StreamController<String?>();
  final passwordErrorController = StreamController<String?>();
  final mainErrorController = StreamController<String?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  LoginPresenterSpy() {
    when(() => auth()).thenAnswer((_) async => _);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitEmailError(String error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(String error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(String error) => mainErrorController.add(error);

  @override
  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets("Should load with correct initial state",
      (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the labels texts',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the labels texts',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Shold call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError('any error');

    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  // testWidgets('Shold call authentication on form submit',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);
  //   presenter.emitLoading(true);
  //   await tester.pump();
  //   await tester.tap(find.byType(ElevatedButton));
  //   await tester.pump();
  //   verify(() => presenter.auth()).called(1);
  // });

  testWidgets('Shold present loading', (WidgetTester tester) async {
    await loadPage(tester);
    presenter.emitLoading(true);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shold hide loading', (WidgetTester tester) async {
    await loadPage(tester);
    presenter.emitLoading(true);
    await tester.pump();
    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Shold present error menssage if authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);
    presenter.emitMainError('main error');

    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  // testWidgets('Shold close streams on dispose', (WidgetTester tester) async {
  //   await loadPage(tester);

  //   addTearDown(() {
  //     verify(() => presenter.dispose());
  //   });
  // });
}
