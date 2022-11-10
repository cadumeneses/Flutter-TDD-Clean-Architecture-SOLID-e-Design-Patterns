import 'package:flutter/material.dart';
import '../login_presenter.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Senha',
          icon: Icon(Icons.lock),
        ),
        obscureText: true,
        onChanged: presenter.validatePassword,
      ),
    );
  }
}