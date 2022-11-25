import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nome',
        icon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
