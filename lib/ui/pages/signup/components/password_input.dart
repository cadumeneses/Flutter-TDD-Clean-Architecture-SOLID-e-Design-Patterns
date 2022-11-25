import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Senha',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}
