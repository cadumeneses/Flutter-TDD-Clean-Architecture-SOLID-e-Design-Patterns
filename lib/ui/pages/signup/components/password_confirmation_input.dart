import 'package:flutter/material.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Confirmar senha',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}
