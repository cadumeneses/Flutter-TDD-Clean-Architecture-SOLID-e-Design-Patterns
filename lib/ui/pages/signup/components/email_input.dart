import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        icon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
