import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_tdd/ui/pages/pages.dart';

void main() {

  Future<void> loadPage(WidgetTester tester) async {
    final singUpPage = GetMaterialApp(
      initialRoute: '/singup',
      getPages: [
        GetPage(name: '/singup', page: () => const SignUpPage()),
        GetPage(
            name: '/fake_page',
            page: () => const Scaffold(
                  body: Text('fake page'),
                )),
      ],
    );
    await tester.pumpWidget(singUpPage);
  }

  testWidgets("Should load with correct initial state",
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(
      nameTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the labels texts',
    );

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the labels texts',
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the labels texts',
    );

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text));
    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the labels texts',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
}
