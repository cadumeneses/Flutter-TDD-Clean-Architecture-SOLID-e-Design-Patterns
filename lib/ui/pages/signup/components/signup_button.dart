import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        null;
      },
      child: Text('Criar conta'.toUpperCase()),
    );
  }
}
