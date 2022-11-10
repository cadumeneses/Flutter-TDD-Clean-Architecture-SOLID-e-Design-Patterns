import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  const LoginPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const HeadLine1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                  child: Column(
                children: [
                  StreamBuilder<String>(
                    stream: presenter.emailErrorStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: const Icon(Icons.email),
                          errorText: snapshot.data
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: presenter.validateEmail,
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      onChanged: presenter.validatePassword,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: presenter.isFormValidStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.data == true ? presenter.auth : null,
                        child: Text('Entrar'.toUpperCase()),
                      );
                    }
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                    label: const Text('Criar conta'),
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
