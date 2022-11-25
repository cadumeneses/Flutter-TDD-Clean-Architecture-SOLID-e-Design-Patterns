import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    void hideKeyboard() {
      final currectFocus = FocusScope.of(context);
      if (!currectFocus.hasPrimaryFocus) {
        currectFocus.unfocus();
      }
    }

    return GestureDetector(
      onTap: hideKeyboard,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const HeadLine1(text: 'Criar conta'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                  child: Column(
                children: [
                  const NameInput(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: EmailInput(),
                  ),
                  const PasswordInput(),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 32,
                    ),
                    child: PasswordConfirmationInput(),
                  ),
                  const SignUpButton(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Entrar'),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
